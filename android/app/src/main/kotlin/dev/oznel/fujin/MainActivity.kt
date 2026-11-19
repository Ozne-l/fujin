package dev.oznel.fujin

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        EventChannel(
            messenger,
            ReduceTransparencyStreamHandler.CHANNEL,
        ).setStreamHandler(ReduceTransparencyStreamHandler(applicationContext.contentResolver))
        MethodChannel(messenger, MediaChannel.CHANNEL).setMethodCallHandler(MediaChannel(this))
        EventChannel(messenger, MediaChannel.PROGRESS_CHANNEL).setStreamHandler(MediaProgressStreamHandler())
    }
}
