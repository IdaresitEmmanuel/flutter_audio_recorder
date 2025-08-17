import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';

class AudioRecorderPcmModel extends AudioRecorderPcm {
  const AudioRecorderPcmModel({required super.timestamp, required super.data});

  factory AudioRecorderPcmModel.fromMap(Map<dynamic, dynamic> data) {
    return AudioRecorderPcmModel(
      timestamp: Duration(milliseconds: (data['timestamp'] as num).toInt()),
      data: (data['data'] as List).map((d) => (d as num).toDouble()).toList(),
    );
  }
}
