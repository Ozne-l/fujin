package dev.oznel.fujin

import android.app.Activity
import android.view.WindowManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MediaChannel(private val activity: Activity) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val arguments = MediaArguments.of(call.arguments)
        val context = activity.applicationContext
        when (call.method) {
            PROBE_VIDEO -> reading(result, arguments) { VideoProbe.of(context, arguments.string(SOURCE)).toMap() }
            EXPORT_VIDEO -> VideoExports.start(context, arguments, result)
            CANCEL_EXPORT -> foreground(result) { VideoExports.cancel(arguments.string(ID)) }
            PROCESS_PHOTO -> background(result) { PhotoPass.process(context, arguments) }
            EXTRACT_FRAME -> reading(result, arguments) { VideoFrames.extract(context, arguments) }
            SET_SECURE -> foreground(result) { secure(arguments.boolean(SECURE)) }
            else -> result.notImplemented()
        }
    }

    private fun secure(on: Boolean) {
        val flag = WindowManager.LayoutParams.FLAG_SECURE
        if (on) activity.window.addFlags(flag) else activity.window.clearFlags(flag)
    }

    private fun foreground(result: MethodChannel.Result, work: () -> Unit) {
        try {
            work()
            result.success(null)
        } catch (error: MediaException) {
            result.error(error.failure.code, error.message, null)
        }
    }

    private fun reading(result: MethodChannel.Result, arguments: MediaArguments, work: () -> Any?) {
        when (arguments.optionalString(SOURCE)?.let(MediaSource::isRemote)) {
            true -> MediaThreads.remote(work) { outcome -> reply(result, outcome) }
            false, null -> background(result, work)
        }
    }

    private fun background(result: MethodChannel.Result, work: () -> Any?) {
        MediaThreads.background(work) { outcome -> reply(result, outcome) }
    }

    private fun reply(result: MethodChannel.Result, outcome: Result<Any?>) {
        outcome.fold(result::success) { error ->
            val failure = MediaException.of(error)
            result.error(failure.failure.code, failure.message, null)
        }
    }

    companion object {
        const val CHANNEL = "dev.oznel.fujin/media"
        const val PROGRESS_CHANNEL = "dev.oznel.fujin/media_progress"
        private const val PROBE_VIDEO = "probeVideo"
        private const val EXPORT_VIDEO = "exportVideo"
        private const val CANCEL_EXPORT = "cancelExport"
        private const val PROCESS_PHOTO = "processPhoto"
        private const val EXTRACT_FRAME = "extractFrame"
        private const val SET_SECURE = "setSecure"
        private const val SOURCE = "source"
        private const val ID = "id"
        private const val SECURE = "secure"
    }
}
