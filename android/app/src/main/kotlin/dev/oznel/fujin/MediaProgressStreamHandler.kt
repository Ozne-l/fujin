package dev.oznel.fujin

import io.flutter.plugin.common.EventChannel

class MediaProgressStreamHandler : EventChannel.StreamHandler {
    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        VideoExports.progressSink = events
    }

    override fun onCancel(arguments: Any?) {
        VideoExports.progressSink = null
    }
}
