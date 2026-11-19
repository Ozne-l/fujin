package dev.oznel.fujin

import android.app.Service
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder

class MediaProcessingService : Service() {
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = MediaNotification.build(this, VideoExports.notice, VideoExports.percent)
        try {
            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.VANILLA_ICE_CREAM -> startForeground(
                    MediaNotification.ID,
                    notification,
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROCESSING,
                )
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q -> startForeground(
                    MediaNotification.ID,
                    notification,
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC,
                )
                else -> startForeground(MediaNotification.ID, notification)
            }
        } catch (error: RuntimeException) {
            VideoExports.lostForeground(error.toString())
            stopSelf()
            return START_NOT_STICKY
        }
        if (!VideoExports.enteredForeground()) stopSelf()
        return START_NOT_STICKY
    }

    override fun onTimeout(startId: Int, fgsType: Int) {
        VideoExports.lostForeground(TIMEOUT)
        stopSelf()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private companion object {
        const val TIMEOUT = "timeout"
    }
}
