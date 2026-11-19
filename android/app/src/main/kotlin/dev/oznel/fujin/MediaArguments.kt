package dev.oznel.fujin

class MediaArguments(private val values: Map<*, *>) {
    fun string(key: String): String = optionalString(key) ?: throw missing(key)

    fun optionalString(key: String): String? = values[key] as? String

    fun long(key: String): Long = (values[key] as? Number)?.toLong() ?: throw missing(key)

    fun int(key: String): Int = (values[key] as? Number)?.toInt() ?: throw missing(key)

    fun boolean(key: String): Boolean = values[key] as? Boolean ?: throw missing(key)

    fun child(key: String): MediaArguments? = (values[key] as? Map<*, *>)?.let(::MediaArguments)

    fun children(key: String): List<MediaArguments> =
        (values[key] as? List<*>).orEmpty().map { value ->
            (value as? Map<*, *>)?.let(::MediaArguments) ?: throw missing(key)
        }

    fun float(key: String): Float = (values[key] as? Number)?.toFloat() ?: throw missing(key)

    fun crop(key: String): CropRect? = child(key)?.let { crop ->
        CropRect(
            left = crop.float(LEFT),
            top = crop.float(TOP),
            right = crop.float(RIGHT),
            bottom = crop.float(BOTTOM),
        )
    }

    private fun missing(key: String) = MediaException(MediaFailure.INVALID_REQUEST, key)

    companion object {
        private const val LEFT = "left"
        private const val TOP = "top"
        private const val RIGHT = "right"
        private const val BOTTOM = "bottom"

        fun of(arguments: Any?): MediaArguments = MediaArguments(arguments as? Map<*, *> ?: emptyMap<Any, Any>())
    }
}
