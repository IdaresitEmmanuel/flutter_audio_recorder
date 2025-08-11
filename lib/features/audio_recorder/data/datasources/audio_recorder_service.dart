import 'package:flutter/services.dart';

abstract class IAudioRecorderService {
  Future<bool?> startRecording();
  Future<bool?> pause();
  Future<bool?> resume();
  Future<bool?> stop();

  Stream<Map<String, dynamic>?> pcmStream();
  Stream<Map<String, dynamic>?> statusStream();
}

class AudioRecorderService extends IAudioRecorderService {
  final MethodChannel _methodChannel;
  final EventChannel _audioRecorderPcmEventChannel;
  final EventChannel _audioRecorderStateEventChannel;

  AudioRecorderService(
    this._methodChannel,
    this._audioRecorderPcmEventChannel,
    this._audioRecorderStateEventChannel,
  );

  @override
  Future<bool?> startRecording() {
    return _methodChannel.invokeMethod("startRecorder");
  }

  @override
  Future<bool?> pause() async {
    return _methodChannel.invokeMethod("pauseRecorder");
  }

  @override
  Future<bool?> resume() {
    return _methodChannel.invokeMethod("resumeRecorder");
  }

  @override
  Future<bool?> stop() {
    return _methodChannel.invokeMethod("stopRecorder");
  }

  @override
  Stream<Map<String, dynamic>?> pcmStream() {
    return _audioRecorderPcmEventChannel.receiveBroadcastStream()
        as Stream<Map<String, dynamic>?>;
  }

  @override
  Stream<Map<String, dynamic>?> statusStream() {
    return _audioRecorderStateEventChannel.receiveBroadcastStream()
        as Stream<Map<String, dynamic>?>;
  }
}
