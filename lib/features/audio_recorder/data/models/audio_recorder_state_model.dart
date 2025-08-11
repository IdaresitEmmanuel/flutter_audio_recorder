import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_state.dart';

class AudioRecorderStateModel extends AudioRecorderState {
  const AudioRecorderStateModel({
    required super.isRecording,
    required super.recordDuration,
  });

  factory AudioRecorderStateModel.fromMap(Map<String, dynamic> data) {
    return AudioRecorderStateModel(
      isRecording: data['isRecording'],
      recordDuration: Duration(
        seconds: (data['recordDuration'] as num).toInt(),
      ),
    );
  }
}
