package com.hyequest.audiorecorder.data.audiorecorder

data class RecordWaveformModel(val timestamp: Double, val data: List<Double>) {

    fun toMap(): Map<String, Any> {
        return mapOf(
            "timestamp" to timestamp,
            "data" to data
        )
    }
}