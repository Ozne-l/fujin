package dev.oznel.fujin

data class VideoExportRequest(
    val id: String,
    val source: String,
    val output: String,
    val poster: String,
    val passages: List<KeptPassage>,
    val crop: CropRect?,
    val muted: Boolean,
    val notice: ExportNotice,
) {
    companion object {
        private const val ID = "id"
        private const val SOURCE = "source"
        private const val OUTPUT = "output"
        private const val POSTER = "poster"
        private const val PASSAGES = "passages"
        private const val START_MS = "start_ms"
        private const val END_MS = "end_ms"
        private const val CROP = "crop"
        private const val MUTED = "muted"
        private const val RECIPIENT = "recipient"
        private const val POSITION = "position"
        private const val COUNT = "count"

        fun of(arguments: MediaArguments): VideoExportRequest {
            val notice = ExportNotice(
                recipient = arguments.optionalString(RECIPIENT),
                position = arguments.int(POSITION),
                count = arguments.int(COUNT),
            )
            return VideoExportRequest(
                id = arguments.string(ID),
                source = arguments.string(SOURCE),
                output = arguments.string(OUTPUT),
                poster = arguments.string(POSTER),
                passages = arguments.children(PASSAGES).map { passage ->
                    KeptPassage(startMs = passage.long(START_MS), endMs = passage.long(END_MS))
                },
                crop = arguments.crop(CROP),
                muted = arguments.boolean(MUTED),
                notice = notice,
            )
        }
    }
}
