package dev.oznel.fujin

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.graphics.RectF
import androidx.exifinterface.media.ExifInterface
import java.io.File
import java.io.IOException
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt

object PhotoPass {
    private const val LONG_SIDE = 2048
    private const val QUALITY = 85
    private const val QUARTER_TURN = 90f
    private const val TURNS = 4
    private const val SOURCE = "source"
    private const val OUTPUT = "output"
    private const val CROP = "crop"
    private const val QUARTER_TURNS = "quarter_turns"
    private const val PATH = "path"
    private const val WIDTH = "width"
    private const val HEIGHT = "height"
    private const val BYTES = "bytes"

    fun process(context: Context, arguments: MediaArguments): Map<String, Any> {
        val source = arguments.string(SOURCE)
        val output = arguments.string(OUTPUT)
        val crop = arguments.crop(CROP)
        val turns = arguments.int(QUARTER_TURNS).mod(TURNS)
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        MediaSource.descriptor(context, source).use { BitmapFactory.decodeFileDescriptor(it.fileDescriptor, null, bounds) }
        if (bounds.outWidth <= 0 || bounds.outHeight <= 0) throw MediaException(MediaFailure.UNREADABLE_SOURCE, source)
        val orientation = orientationOf(context, source)

        val uprightFromSource = orientationMatrix(orientation)
        val upright = RectF().also {
            uprightFromSource.mapRect(it, RectF(0f, 0f, bounds.outWidth.toFloat(), bounds.outHeight.toFloat()))
        }
        uprightFromSource.postTranslate(-upright.left, -upright.top)
        val cropUpright = crop?.let {
            RectF(
                it.left * upright.width(),
                it.top * upright.height(),
                it.right * upright.width(),
                it.bottom * upright.height(),
            )
        } ?: RectF(0f, 0f, upright.width(), upright.height())
        val cropSource = RectF().also { Matrix().apply { uprightFromSource.invert(this) }.mapRect(it, cropUpright) }

        val longSide = max(cropSource.width(), cropSource.height())
        var sample = 1
        while (longSide / (sample * 2) >= LONG_SIDE) sample *= 2
        val decoded = MediaSource.descriptor(context, source).use {
            BitmapFactory.decodeFileDescriptor(it.fileDescriptor, null, BitmapFactory.Options().apply { inSampleSize = sample })
        } ?: throw MediaException(MediaFailure.UNREADABLE_SOURCE, source)
        try {
            val sx = decoded.width.toFloat() / bounds.outWidth
            val sy = decoded.height.toFloat() / bounds.outHeight
            val x = (cropSource.left * sx).roundToInt().coerceIn(0, decoded.width - 1)
            val y = (cropSource.top * sy).roundToInt().coerceIn(0, decoded.height - 1)
            val width = (cropSource.width() * sx).roundToInt().coerceIn(1, decoded.width - x)
            val height = (cropSource.height() * sy).roundToInt().coerceIn(1, decoded.height - y)
            val scale = min(1f, LONG_SIDE.toFloat() / max(width, height))
            val matrix = orientationMatrix(orientation).apply {
                postRotate(turns * QUARTER_TURN)
                postScale(scale, scale)
            }
            val out = Bitmap.createBitmap(decoded, x, y, width, height, matrix, true)
            try {
                MediaFiles.writeJpeg(out, output, QUALITY)
                return mapOf(PATH to output, WIDTH to out.width, HEIGHT to out.height, BYTES to File(output).length())
            } finally {
                if (out !== decoded) out.recycle()
            }
        } finally {
            decoded.recycle()
        }
    }

    private fun orientationOf(context: Context, source: String): Int =
        try {
            MediaSource.descriptor(context, source).use {
                ExifInterface(it.fileDescriptor).getAttributeInt(
                    ExifInterface.TAG_ORIENTATION,
                    ExifInterface.ORIENTATION_NORMAL,
                )
            }
        } catch (error: IOException) {
            ExifInterface.ORIENTATION_NORMAL
        }

    private fun orientationMatrix(orientation: Int) = Matrix().apply {
        when (orientation) {
            ExifInterface.ORIENTATION_FLIP_HORIZONTAL -> postScale(-1f, 1f)
            ExifInterface.ORIENTATION_ROTATE_180 -> postRotate(2 * QUARTER_TURN)
            ExifInterface.ORIENTATION_FLIP_VERTICAL -> postScale(1f, -1f)
            ExifInterface.ORIENTATION_TRANSPOSE -> {
                postRotate(QUARTER_TURN)
                postScale(-1f, 1f)
            }
            ExifInterface.ORIENTATION_ROTATE_90 -> postRotate(QUARTER_TURN)
            ExifInterface.ORIENTATION_TRANSVERSE -> {
                postRotate(-QUARTER_TURN)
                postScale(-1f, 1f)
            }
            ExifInterface.ORIENTATION_ROTATE_270 -> postRotate(3 * QUARTER_TURN)
            else -> Unit
        }
    }
}
