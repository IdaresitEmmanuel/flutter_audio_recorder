abstract class AudioRecorderEvent {}

class StartAudioRecorder extends AudioRecorderEvent{}

class PauseAudioRecorder extends AudioRecorderEvent{}

class ResumeAudioRecorder extends AudioRecorderEvent{}

class StopAudioRecorder extends AudioRecorderEvent{}

class GetAudioRecorderPcmStream extends AudioRecorderEvent{}

class GetAudioRecorderStatusStream extends AudioRecorderEvent{}