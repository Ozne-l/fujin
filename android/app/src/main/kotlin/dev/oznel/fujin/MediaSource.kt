package dev.oznel.fujin

import android.content.ContentResolver
import android.content.Context
import android.media.MediaExtractor
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.os.ParcelFileDescriptor
import java.io.File
import java.io.IOException
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL

object MediaSource {
    private const val READ = "r"
    private const val HEAD = "HEAD"
    private const val NETWORK_TIMEOUT_MS = 10_000
    private val REMOTE_SCHEMES = setOf("http", "https")
    private val SUCCESS = 200..299

    fun uri(source: String): Uri {
        val parsed = Uri.parse(source)
        return when (parsed.scheme) {
            ContentResolver.SCHEME_CONTENT, ContentResolver.SCHEME_FILE -> parsed
            else -> Uri.fromFile(File(source))
        }
    }

    fun isRemote(source: String): Boolean = Uri.parse(source).scheme in REMOTE_SCHEMES

    fun unreadable(source: String, error: Throwable?): MediaException = MediaException(
        if (isRemote(source)) MediaFailure.NETWORK_FAILED else MediaFailure.UNREADABLE_SOURCE,
        source,
        error,
    )

    fun open(retriever: MediaMetadataRetriever, context: Context, source: String) {
        if (isRemote(source)) {
            ensureReachable(source)
            retriever.setDataSource(source, emptyMap())
        } else {
            retriever.setDataSource(context, uri(source))
        }
    }

    fun open(extractor: MediaExtractor, context: Context, source: String) {
        if (isRemote(source)) {
            extractor.setDataSource(source, emptyMap())
        } else {
            extractor.setDataSource(context, uri(source), null)
        }
    }

    private fun ensureReachable(source: String) {
        val connection = try {
            URL(source).openConnection() as HttpURLConnection
        } catch (error: IOException) {
            throw MediaException(MediaFailure.NETWORK_FAILED, source, error)
        }
        try {
            connection.requestMethod = HEAD
            connection.connectTimeout = NETWORK_TIMEOUT_MS
            connection.readTimeout = NETWORK_TIMEOUT_MS
            val status = connection.responseCode
            if (status !in SUCCESS) throw MediaException(MediaFailure.NETWORK_FAILED, "$status $source")
        } catch (error: IOException) {
            throw MediaException(MediaFailure.NETWORK_FAILED, source, error)
        } finally {
            connection.disconnect()
        }
    }

    fun descriptor(context: Context, source: String): ParcelFileDescriptor =
        opening(source) { context.contentResolver.openFileDescriptor(uri(source), READ) }

    fun stream(context: Context, source: String): InputStream =
        opening(source) { context.contentResolver.openInputStream(uri(source)) }

    private fun <T> opening(source: String, attempt: () -> T?): T =
        try {
            attempt() ?: throw MediaException(MediaFailure.UNREADABLE_SOURCE, source)
        } catch (error: IOException) {
            throw MediaException(MediaFailure.UNREADABLE_SOURCE, source, error)
        } catch (error: SecurityException) {
            throw MediaException(MediaFailure.UNREADABLE_SOURCE, source, error)
        } catch (error: IllegalArgumentException) {
            throw MediaException(MediaFailure.UNREADABLE_SOURCE, source, error)
        }
}
