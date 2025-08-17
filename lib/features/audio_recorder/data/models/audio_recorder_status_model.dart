import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_status.dart';

class AudioRecorderStatusModel extends AudioRecorderStatus {
  const AudioRecorderStatusModel({
    required super.isRecording,
    required super.recordDuration,
  });

  factory AudioRecorderStatusModel.fromMap(Map<dynamic, dynamic> data) {
    return AudioRecorderStatusModel(
      isRecording: data['isRecording'],
      recordDuration: Duration(
        milliseconds: (data['recordDuration'] as num).toInt(),
      ),
    );
  }
}
