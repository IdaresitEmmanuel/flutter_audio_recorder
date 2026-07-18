import 'package:audiorecorder/core/resources/data_error.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_status.dart';
import 'package:equatable/equatable.dart';

abstract class AudioRecorderState extends Equatable {}

class AudioRecorderStateActive extends AudioRecorderState {
  final AudioRecorderStatus recorderStatus;
  // final List<AudioRecorderPcm> pcm;

  AudioRecorderStateActive({
    required this.recorderStatus,
    // , required this.pcm
  });

  AudioRecorderStateActive copyWith({
    AudioRecorderStatus? recorderStatus,
    List<AudioRecorderPcm>? pcm,
  }) {
    return AudioRecorderStateActive(
      recorderStatus: recorderStatus ?? this.recorderStatus,
      // pcm: pcm ?? this.pcm,
    );
  }

  factory AudioRecorderStateActive.initial() => AudioRecorderStateActive(
    recorderStatus: AudioRecorderStatus(
      isRecording: false,
      recordDuration: Duration.zero,
    ),
    // pcm: [],
  );

  @override
  List<Object?> get props => [
    recorderStatus,
    // , pcm
  ];
}

class AudioRecordStateError extends AudioRecorderState {
  final DataError error;

  AudioRecordStateError({required this.error});
  @override
  List<Object?> get props => [error];
}
