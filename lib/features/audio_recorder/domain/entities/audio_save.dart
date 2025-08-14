import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:equatable/equatable.dart';

class AudioSave extends Equatable {
  final List<AudioRecorderPcm> data;
  final String title;

  const AudioSave({required this.data, required this.title});

  @override
  List<Object?> get props => [data, title];
}
