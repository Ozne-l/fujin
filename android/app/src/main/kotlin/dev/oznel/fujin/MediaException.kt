package dev.oznel.fujin

class MediaException(
    val failure: MediaFailure,
    message: String?,
    cause: Throwable? = null,
) : Exception(message, cause) {
    companion object {
        fun of(error: Throwable): MediaException = when (error) {
            is MediaException -> error
            else -> MediaException(MediaFailure.FAILED, error.toString(), error)
        }
    }
}
