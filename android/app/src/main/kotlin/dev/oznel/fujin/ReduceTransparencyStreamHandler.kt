package dev.oznel.fujin

import android.content.ContentResolver
import android.database.ContentObserver
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import io.flutter.plugin.common.EventChannel

class ReduceTransparencyStreamHandler(
    private val resolver: ContentResolver,
) : EventChannel.StreamHandler {
    private var observer: ContentObserver? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        stopObserving()
        val observer = object : ContentObserver(Handler(Looper.getMainLooper())) {
            override fun onChange(selfChange: Boolean) {
                events.success(enabled())
            }
        }
        resolver.registerContentObserver(Settings.Global.getUriFor(REDUCE_TRANSPARENCY), false, observer)
        resolver.registerContentObserver(Settings.Secure.getUriFor(HIGH_TEXT_CONTRAST), false, observer)
        this.observer = observer
        events.success(enabled())
    }

    override fun onCancel(arguments: Any?) {
        stopObserving()
    }

    private fun stopObserving() {
        observer?.let(resolver::unregisterContentObserver)
        observer = null
    }

    private fun enabled(): Boolean =
        Settings.Global.getInt(resolver, REDUCE_TRANSPARENCY, OFF) != OFF ||
            Settings.Secure.getInt(resolver, HIGH_TEXT_CONTRAST, OFF) != OFF

    companion object {
        const val CHANNEL = "dev.oznel.fujin/reduce_transparency"
        private const val REDUCE_TRANSPARENCY = "accessibility_reduce_transparency"
        private const val HIGH_TEXT_CONTRAST = "high_text_contrast_enabled"
        private const val OFF = 0
    }
}
