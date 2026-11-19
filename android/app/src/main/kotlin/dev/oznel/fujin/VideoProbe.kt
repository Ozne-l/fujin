package dev.oznel.fujin

import android.content.Context
import android.media.MediaExtractor
import android.media.MediaFormat
import android.media.MediaMetadataRetriever
import java.io.IOException

data class VideoProbe(
    val width: Int,
    val height: Int,
    val rotation: Int,
    val durationMs: Long,
    val hdr: Boolean,
) {
    val uprightWidth: Int get() = if (rotation % HALF_TURN == 0) width else height

    val uprightHeight: Int get() = if (rotation % HALF_TURN == 0) height else width

    fun toMap(): Map<String, Any> = mapOf(
        UPRIGHT_WIDTH to uprightWidth,
        UPRIGHT_HEIGHT to uprightHeight,
        ROTATION to rotation,
        DURATION_MS to durationMs,
        HDR to hdr,
    )

    companion object {
        const val UPRIGHT_WIDTH = "upright_width"
        const val UPRIGHT_HEIGHT = "upright_height"
        const val DURATION_MS = "duration_ms"
        private const val ROTATION = "rotation"
        private const val HDR = "hdr"
        private const val HALF_TURN = 180
        private const val VIDEO_MIME_PREFIX = "video/"
        private val HDR_TRANSFERS = setOf(MediaFormat.COLOR_TRANSFER_ST2084, MediaFormat.COLOR_TRANSFER_HLG)

        fun of(context: Context, source: String): VideoProbe {
            val retriever = MediaMetadataRetriever()
            try {
                MediaSource.open(retriever, context, source)
                return VideoProbe(
                    width = retriever.number(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH, source).toInt(),
                    height = retriever.number(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT, source).toInt(),
                    rotation = retriever.number(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION, source).toInt(),
                    durationMs = retriever.number(MediaMetadataRetriever.METADATA_KEY_DURATION, source),
                    hdr = isHdr(context, source),
                )
            } catch (error: RuntimeException) {
                throw MediaSource.unreadable(source, error)
            } finally {
                retriever.release()
            }
        }

        private fun MediaMetadataRetriever.number(key: Int, source: String): Long =
            extractMetadata(key)?.toLongOrNull() ?: throw MediaSource.unreadable(source, null)

        private fun isHdr(context: Context, source: String): Boolean {
            val extractor = MediaExtractor()
            try {
                MediaSource.open(extractor, context, source)
                return (0 until extractor.trackCount).map(extractor::getTrackFormat).any { format ->
                    format.getString(MediaFormat.KEY_MIME)?.startsWith(VIDEO_MIME_PREFIX) == true &&
                        format.containsKey(MediaFormat.KEY_COLOR_TRANSFER) &&
                        format.getInteger(MediaFormat.KEY_COLOR_TRANSFER) in HDR_TRANSFERS
                }
            } catch (error: IOException) {
                throw MediaSource.unreadable(source, error)
            } finally {
                extractor.release()
            }
        }
    }
}
