import 'package:flutter/services.dart';

abstract class IAudioRecorderService {
  Future<bool?> requestPermission();
  Future<bool?> startRecording();
  Future<bool?> pause();
  Future<bool?> resume();
  Future<bool?> stop();

  Stream<Map<dynamic, dynamic>?> pcmStream();
  Stream<Map<dynamic, dynamic>?> statusStream();
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
  Future<bool?> requestPermission() {
    return _methodChannel.invokeMethod("requestMicrophonePermission");
  }

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
  Stream<Map<dynamic, dynamic>?> pcmStream() {
    return _audioRecorderPcmEventChannel
        .receiveBroadcastStream()
        .map<Map<dynamic, dynamic>?>((s) => s);
  }

  @override
  Stream<Map<dynamic, dynamic>?> statusStream() {
    return _audioRecorderStateEventChannel
        .receiveBroadcastStream()
        .map<Map<dynamic, dynamic>?>((s) => s);
  }

  
}
