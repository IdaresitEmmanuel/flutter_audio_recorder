import 'package:equatable/equatable.dart';

class AudioRecorderStatus extends Equatable {
  final bool isRecording;
  final Duration recordDuration;

  const AudioRecorderStatus({
    required this.isRecording,
    required this.recordDuration,
  });

  @override
  List<Object?> get props => [isRecording, recordDuration];
}
