package dev.oznel.fujin

import android.content.Context
import android.graphics.Bitmap
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

object MediaFiles {
    fun writeJpeg(bitmap: Bitmap, path: String, quality: Int) = writing(path) {
        FileOutputStream(prepared(path)).use { stream ->
            if (!bitmap.compress(Bitmap.CompressFormat.JPEG, quality, stream)) {
                throw MediaException(MediaFailure.WRITE_FAILED, path)
            }
        }
    }

    fun copy(context: Context, source: String, path: String) {
        MediaSource.stream(context, source).use { input ->
            writing(path) { FileOutputStream(prepared(path)).use { output -> input.copyTo(output) } }
        }
    }

    fun delete(path: String) {
        File(path).delete()
    }

    private fun prepared(path: String): File = File(path).also { it.parentFile?.mkdirs() }

    private fun writing(path: String, write: () -> Unit) {
        try {
            write()
        } catch (error: IOException) {
            File(path).delete()
            throw MediaException(MediaFailure.WRITE_FAILED, path, error)
        }
    }
}
