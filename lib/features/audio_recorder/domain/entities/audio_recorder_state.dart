import 'package:equatable/equatable.dart';

class AudioRecorderState extends Equatable {
  final bool isRecording;
  final Duration recordDuration;

  const AudioRecorderState({required this.isRecording, required this.recordDuration});
  
  @override
  List<Object?> get props => [isRecording, recordDuration];
}
