import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';

class AudioRecorderPcmModel extends AudioRecorderPcm {
  const AudioRecorderPcmModel({required super.timestamp, required super.data});

  factory AudioRecorderPcmModel.fromMap(Map<String, dynamic> data) {
    return AudioRecorderPcmModel(
      timestamp: Duration(seconds: (data['timestamp'] as num).toInt()),
      data: (data['data'] as List<num>).map((d) => d.toDouble()).toList(),
    );
  }
}
