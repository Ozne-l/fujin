package dev.oznel.fujin

data class CropRect(
    val left: Float,
    val top: Float,
    val right: Float,
    val bottom: Float,
) {
    init {
        if (!(left in EDGE_RANGE && right in EDGE_RANGE && left < right &&
                top in EDGE_RANGE && bottom in EDGE_RANGE && top < bottom)
        ) {
            throw MediaException(MediaFailure.INVALID_REQUEST, "crop $this")
        }
    }

    companion object {
        private val EDGE_RANGE = 0f..1f
    }
}
