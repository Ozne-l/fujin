package dev.oznel.fujin

data class ExportNotice(
    val recipient: String?,
    val position: Int,
    val count: Int,
) {
    init {
        if (count < 1 || position !in 1..count) {
            throw MediaException(MediaFailure.INVALID_REQUEST, "notice $this")
        }
    }
}
