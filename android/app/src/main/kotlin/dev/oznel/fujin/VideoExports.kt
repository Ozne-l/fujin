package dev.oznel.fujin

import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

object VideoExports {
    private const val ID = "id"
    private const val PERCENT = "percent"

    var progressSink: EventChannel.EventSink? = null
    private var current: VideoExport? = null
    private var serviceInForeground = false

    val notice: ExportNotice? get() = current?.request?.notice

    val percent: Int get() = current?.percent ?: 0

    fun start(context: Context, arguments: MediaArguments, result: MethodChannel.Result) {
        val request = try {
            VideoExportRequest.of(arguments)
        } catch (error: MediaException) {
            result.fail(error)
            return
        }
        if (current != null) {
            result.fail(MediaException(MediaFailure.BUSY, request.id))
            return
        }
        val application = context.applicationContext
        val export = VideoExport(
            context = application,
            request = request,
            foreground = { startService(application) },
            onProgress = { percent ->
                progressSink?.success(mapOf(ID to request.id, PERCENT to percent))
                MediaNotification.show(application, request.notice, percent)
            },
            onFinished = { outcome ->
                current = null
                stopService(application)
                outcome.fold(result::success) { result.fail(MediaException.of(it)) }
            },
        )
        current = export
        export.start()
    }

    fun cancel(id: String) {
        current?.takeIf { it.request.id == id }?.cancel()
    }

    fun enteredForeground(): Boolean {
        serviceInForeground = current != null
        return serviceInForeground
    }

    fun lostForeground(reason: String) {
        serviceInForeground = false
        current?.fail(MediaException(MediaFailure.FOREGROUND_REFUSED, reason))
    }

    private fun startService(context: Context) {
        try {
            ContextCompat.startForegroundService(context, Intent(context, MediaProcessingService::class.java))
        } catch (error: IllegalStateException) {
            throw MediaException(MediaFailure.FOREGROUND_REFUSED, error.toString(), error)
        } catch (error: SecurityException) {
            throw MediaException(MediaFailure.FOREGROUND_REFUSED, error.toString(), error)
        }
    }

    private fun stopService(context: Context) {
        if (!serviceInForeground) return
        serviceInForeground = false
        context.stopService(Intent(context, MediaProcessingService::class.java))
    }

    private fun MethodChannel.Result.fail(error: MediaException) {
        error(error.failure.code, error.message, null)
    }
}
