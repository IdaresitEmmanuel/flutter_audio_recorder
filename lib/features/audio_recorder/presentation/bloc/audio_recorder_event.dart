abstract class AudioRecorderEvent {}

class RequestRecordPermission extends AudioRecorderEvent {}

class StartAudioRecorder extends AudioRecorderEvent {}

class PauseAudioRecorder extends AudioRecorderEvent {}

class ResumeAudioRecorder extends AudioRecorderEvent {}

class StopAudioRecorder extends AudioRecorderEvent {}

class GetAudioRecorderPcmStream extends AudioRecorderEvent {}

class GetAudioRecorderStatusStream extends AudioRecorderEvent {}

class SaveAudioRecording extends AudioRecorderEvent {
  final String? title;

  SaveAudioRecording({this.title});
}

class DiscardAudioRecording extends AudioRecorderEvent {}

class RestartAudioRecording extends AudioRecorderEvent {}
