package dev.oznel.fujin

enum class MediaFailure(val code: String) {
    INVALID_REQUEST("invalidRequest"),
    UNREADABLE_SOURCE("unreadableSource"),
    NETWORK_FAILED("networkFailed"),
    WRITE_FAILED("writeFailed"),
    EXPORT_FAILED("exportFailed"),
    BUSY("busy"),
    CANCELLED("cancelled"),
    FOREGROUND_REFUSED("foregroundRefused"),
    FAILED("failed"),
}
