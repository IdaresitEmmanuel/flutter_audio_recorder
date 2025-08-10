package com.hyequest.audiorecorder.data.audiorecorder

data class RecordStatusModel(
    val isRecording: Boolean,
    val recordDuration: Double
) {
    fun toMap(): Map<String, Any> {
        return mapOf(
            "isRecording" to isRecording,
            "recordDuration" to recordDuration
        )
    }
}