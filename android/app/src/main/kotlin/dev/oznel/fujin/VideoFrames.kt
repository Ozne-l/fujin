package dev.oznel.fujin

import android.content.Context
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.os.Build
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt

object VideoFrames {
    private const val QUALITY = 80
    private const val MICROS_PER_MILLI = 1000L
    private const val PATH = "path"
    private const val WIDTH = "width"
    private const val HEIGHT = "height"
    private const val SOURCE = "source"
    private const val OUTPUT = "output"
    private const val AT_MS = "at_ms"
    private const val MAX_SIZE = "max_size"

    fun extract(context: Context, arguments: MediaArguments): Map<String, Any>? {
        val atMs = arguments.long(AT_MS)
        val maxSize = arguments.int(MAX_SIZE)
        if (atMs < 0 || maxSize <= 0) throw MediaException(MediaFailure.INVALID_REQUEST, "$atMs $maxSize")
        return extract(context, arguments.string(SOURCE), atMs, maxSize, arguments.string(OUTPUT))
    }

    fun extract(context: Context, source: String, atMs: Long, maxSize: Int, output: String): Map<String, Any>? {
        val retriever = MediaMetadataRetriever()
        try {
            MediaSource.open(retriever, context, source)
            return write(retriever, atMs, maxSize, output)
        } catch (error: RuntimeException) {
            throw MediaSource.unreadable(source, error)
        } finally {
            retriever.release()
        }
    }

    private fun write(retriever: MediaMetadataRetriever, atMs: Long, maxSize: Int, output: String): Map<String, Any>? {
        val frame = retriever.frameWithin(atMs * MICROS_PER_MILLI, maxSize) ?: return null
        try {
            MediaFiles.writeJpeg(frame, output, QUALITY)
            return mapOf(PATH to output, WIDTH to frame.width, HEIGHT to frame.height)
        } finally {
            frame.recycle()
        }
    }

    private fun MediaMetadataRetriever.frameWithin(timeUs: Long, maxSize: Int): Bitmap? =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            getScaledFrameAtTime(timeUs, MediaMetadataRetriever.OPTION_CLOSEST_SYNC, maxSize, maxSize)
        } else {
            getFrameAtTime(timeUs, MediaMetadataRetriever.OPTION_CLOSEST_SYNC)?.let { frame -> fitted(frame, maxSize) }
        }

    private fun fitted(frame: Bitmap, maxSize: Int): Bitmap {
        val scale = min(1f, maxSize.toFloat() / max(frame.width, frame.height))
        if (scale == 1f) return frame
        val fitted = Bitmap.createScaledBitmap(
            frame,
            (frame.width * scale).roundToInt(),
            (frame.height * scale).roundToInt(),
            true,
        )
        frame.recycle()
        return fitted
    }
}
