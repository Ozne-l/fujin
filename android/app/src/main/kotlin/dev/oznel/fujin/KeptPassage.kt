package dev.oznel.fujin

data class KeptPassage(val startMs: Long, val endMs: Long) {
    init {
        if (startMs < 0 || endMs <= startMs) {
            throw MediaException(MediaFailure.INVALID_REQUEST, "passage $this")
        }
    }
}
