import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_status.dart';

class AudioRecorderStatusModel extends AudioRecorderStatus {
  const AudioRecorderStatusModel({
    required super.isRecording,
    required super.recordDuration,
  });

  factory AudioRecorderStatusModel.fromMap(Map<String, dynamic> data) {
    return AudioRecorderStatusModel(
      isRecording: data['isRecording'],
      recordDuration: Duration(
        seconds: (data['recordDuration'] as num).toInt(),
      ),
    );
  }
}
