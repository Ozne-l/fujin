package dev.oznel.fujin

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ReduceTransparencyStreamHandler.CHANNEL,
        ).setStreamHandler(ReduceTransparencyStreamHandler(applicationContext.contentResolver))
    }
}
