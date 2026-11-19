package dev.oznel.fujin

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat

object MediaNotification {
    const val ID = 4601
    const val CHANNEL_ID = "background_downloader"
    private const val FULL = 100
    private const val LAUNCH_REQUEST = 0

    fun build(context: Context, notice: ExportNotice?, percent: Int): Notification {
        createChannel(context)
        val resources = context.resources
        val count = notice?.count ?: 1
        val detail = when {
            notice == null -> null
            notice.count > 1 -> resources.getString(R.string.media_position, notice.position, notice.count)
            else -> notice.recipient?.let { resources.getString(R.string.media_for_recipient, it) }
        }
        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher_monochrome)
            .setContentTitle(resources.getQuantityString(R.plurals.media_preparing_videos, count))
            .setContentText(detail)
            .setSubText(resources.getString(R.string.media_percent, percent))
            .setProgress(FULL, percent, false)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setSilent(true)
            .setCategory(NotificationCompat.CATEGORY_PROGRESS)
            .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
            .setContentIntent(launch(context))
            .build()
    }

    fun show(context: Context, notice: ExportNotice, percent: Int) {
        context.getSystemService(NotificationManager::class.java).notify(ID, build(context, notice, percent))
    }

    private fun createChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val channel = NotificationChannel(
            CHANNEL_ID,
            context.getString(R.string.media_channel_name),
            NotificationManager.IMPORTANCE_LOW,
        ).apply { description = context.getString(R.string.media_channel_description) }
        context.getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
    }

    private fun launch(context: Context): PendingIntent? =
        context.packageManager.getLaunchIntentForPackage(context.packageName)?.let { intent ->
            PendingIntent.getActivity(
                context,
                LAUNCH_REQUEST,
                intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
            )
        }
}
