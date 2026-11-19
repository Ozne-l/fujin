package dev.oznel.fujin

import android.content.Context
import androidx.annotation.OptIn
import androidx.media3.common.Effect
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.common.util.GlUtil
import androidx.media3.common.util.Size
import androidx.media3.common.util.UnstableApi
import androidx.media3.container.Mp4OrientationData
import androidx.media3.effect.Crop
import androidx.media3.effect.Presentation
import androidx.media3.transformer.Composition
import androidx.media3.transformer.DefaultEncoderFactory
import androidx.media3.transformer.EditedMediaItem
import androidx.media3.transformer.EditedMediaItemSequence
import androidx.media3.transformer.Effects
import androidx.media3.transformer.ExportException
import androidx.media3.transformer.ExportResult
import androidx.media3.transformer.InAppMp4Muxer
import androidx.media3.transformer.ProgressHolder
import androidx.media3.transformer.Transformer
import androidx.media3.transformer.VideoEncoderSettings
import java.io.File
import kotlin.math.min

@OptIn(UnstableApi::class)
class VideoExport(
    private val context: Context,
    val request: VideoExportRequest,
    private val foreground: () -> Unit,
    private val onProgress: (Int) -> Unit,
    private val onFinished: (Result<Map<String, Any?>>) -> Unit,
) {
    private var transformer: Transformer? = null
    private var finished = false
    private var lastPercent = NO_PROGRESS
    private val holder = ProgressHolder()
    private val poll = Runnable { poll() }

    val percent: Int get() = lastPercent.coerceAtLeast(0)

    fun start() {
        MediaThreads.background({ VideoProbe.of(context, request.source) }) { probe ->
            if (!finished) probe.fold(::begin) { fail(MediaException.of(it)) }
        }
    }

    fun cancel() {
        fail(MediaException(MediaFailure.CANCELLED, request.id))
    }

    fun fail(error: MediaException) {
        if (finished) return
        transformer?.cancel()
        transformer = null
        stopPolling()
        discardFiles()
        finish(Result.failure(error))
    }

    private fun begin(probe: VideoProbe) {
        try {
            foreground()
        } catch (error: MediaException) {
            fail(error)
            return
        }
        attempt(probe, modes(probe), 0)
    }

    private fun modes(probe: VideoProbe): List<Int?> = when {
        !probe.hdr -> listOf(null)
        GlUtil.isYuvTargetExtensionSupported() -> listOf(
            Composition.HDR_MODE_TONE_MAP_HDR_TO_SDR_USING_OPEN_GL,
            Composition.HDR_MODE_TONE_MAP_HDR_TO_SDR_USING_MEDIACODEC,
        )
        else -> listOf(Composition.HDR_MODE_TONE_MAP_HDR_TO_SDR_USING_MEDIACODEC)
    }

    private fun attempt(probe: VideoProbe, modes: List<Int?>, index: Int) {
        val mode = modes[index]
        val transformer = Transformer.Builder(context)
            .setVideoMimeType(MimeTypes.VIDEO_H264)
            .setEncoderFactory(
                DefaultEncoderFactory.Builder(context)
                    .setRequestedVideoEncoderSettings(VideoEncoderSettings.Builder().setBitrate(BITRATE).build())
                    .build(),
            )
            .setMuxerFactory(InAppMp4Muxer.Factory { entries -> entries.removeAll { it !is Mp4OrientationData } })
            .addListener(object : Transformer.Listener {
                override fun onCompleted(composition: Composition, exportResult: ExportResult) {
                    completed(if (mode == null) Outcome.ENCODED else Outcome.TONE_MAPPED)
                }

                override fun onError(
                    composition: Composition,
                    exportResult: ExportResult,
                    exportException: ExportException,
                ) {
                    failed(probe, modes, index, exportException)
                }
            })
            .build()
        this.transformer = transformer
        lastPercent = NO_PROGRESS
        try {
            transformer.start(composition(probe, mode), request.output)
        } catch (error: RuntimeException) {
            fail(MediaException(MediaFailure.EXPORT_FAILED, error.toString(), error))
            return
        }
        schedulePoll()
    }

    private fun composition(probe: VideoProbe, mode: Int?): Composition {
        val uri = MediaSource.uri(request.source)
        val passages: List<KeptPassage?> = request.passages.ifEmpty { listOf(null) }
        val items = passages.map { passage ->
            val item = MediaItem.Builder().setUri(uri)
            passage?.let {
                item.setClippingConfiguration(
                    MediaItem.ClippingConfiguration.Builder()
                        .setStartPositionMs(it.startMs)
                        .setEndPositionMs(it.endMs)
                        .build(),
                )
            }
            EditedMediaItem.Builder(item.build())
                .setEffects(Effects(listOf(), effects(probe)))
                .setRemoveAudio(request.muted)
                .build()
        }
        val composition = Composition.Builder(EditedMediaItemSequence.Builder(items).build())
        mode?.let(composition::setHdrMode)
        return composition.build()
    }

    private fun effects(probe: VideoProbe): List<Effect> {
        val crop = request.crop?.let {
            Crop(2f * it.left - 1f, 2f * it.right - 1f, 1f - 2f * it.bottom, 1f - 2f * it.top)
        }
        val size = crop?.configure(probe.uprightWidth, probe.uprightHeight)
            ?: Size(probe.uprightWidth, probe.uprightHeight)
        val presentation = Presentation.createForShortSide(MAX_SHORT_SIDE)
            .takeIf { min(size.width, size.height) > MAX_SHORT_SIDE }
        return listOfNotNull(crop, presentation)
    }

    private fun completed(outcome: Outcome) {
        transformer = null
        stopPolling()
        deliver(outcome) {}
    }

    private fun failed(probe: VideoProbe, modes: List<Int?>, index: Int, error: ExportException) {
        transformer = null
        stopPolling()
        MediaFiles.delete(request.output)
        when {
            index + 1 < modes.size -> attempt(probe, modes, index + 1)
            probe.hdr -> deliver(Outcome.ORIGINAL) { MediaFiles.copy(context, request.source, request.output) }
            else -> fail(MediaException(MediaFailure.EXPORT_FAILED, "${error.errorCodeName}: ${error.message}", error))
        }
    }

    private fun deliver(outcome: Outcome, prepare: () -> Unit) {
        MediaThreads.background({
            prepare()
            describe(outcome)
        }) { described ->
            if (finished) {
                discardFiles()
            } else {
                described.fold({ finish(Result.success(it)) }) { fail(MediaException.of(it)) }
            }
        }
    }

    private fun describe(outcome: Outcome): Map<String, Any?> {
        val video = VideoProbe.of(context, request.output)
        val posterAtMs = min(POSTER_AT_MS, video.durationMs / 2)
        val poster = VideoFrames.extract(context, request.output, posterAtMs, POSTER_SIZE, request.poster)
        return mapOf(
            PATH to request.output,
            BYTES to File(request.output).length(),
            VideoProbe.DURATION_MS to video.durationMs,
            VideoProbe.UPRIGHT_WIDTH to video.uprightWidth,
            VideoProbe.UPRIGHT_HEIGHT to video.uprightHeight,
            POSTER to poster?.let { request.poster },
            OUTCOME to outcome.code,
        )
    }

    private fun schedulePoll() {
        MediaThreads.main.postDelayed(poll, POLL_MS)
    }

    private fun stopPolling() {
        MediaThreads.main.removeCallbacks(poll)
    }

    private fun poll() {
        val transformer = transformer ?: return
        if (transformer.getProgress(holder) == Transformer.PROGRESS_STATE_AVAILABLE &&
            holder.progress != lastPercent
        ) {
            lastPercent = holder.progress
            onProgress(holder.progress)
        }
        schedulePoll()
    }

    private fun discardFiles() {
        MediaFiles.delete(request.output)
        MediaFiles.delete(request.poster)
    }

    private fun finish(outcome: Result<Map<String, Any?>>) {
        finished = true
        onFinished(outcome)
    }

    private enum class Outcome(val code: String) {
        ENCODED("encoded"),
        TONE_MAPPED("toneMapped"),
        ORIGINAL("original"),
    }

    private companion object {
        const val BITRATE = 6_000_000
        const val MAX_SHORT_SIDE = 1080
        const val POSTER_AT_MS = 1000L
        const val POSTER_SIZE = 720
        const val POLL_MS = 250L
        const val NO_PROGRESS = -1
        const val PATH = "path"
        const val BYTES = "bytes"
        const val POSTER = "poster"
        const val OUTCOME = "outcome"
    }
}
