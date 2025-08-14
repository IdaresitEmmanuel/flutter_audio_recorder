import 'package:audiorecorder/features/audio_recorder/data/datasources/audio_recorder_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

class MockAudioRecorderPcmChannel extends Mock implements EventChannel {}

class MockAudioRecorderStateChannel extends Mock implements EventChannel {}

void main() {
  final mockMethodChannel = MockMethodChannel();
  final mockAudioRecorderPcmChannel = MockAudioRecorderPcmChannel();
  final mockAudioRecorderStateChannel = MockAudioRecorderStateChannel();

  final audioRecorderService = AudioRecorderService(
    mockMethodChannel,
    mockAudioRecorderPcmChannel,
    mockAudioRecorderStateChannel,
  );

  test('should invoke requestPermission', () async {
    when(
      () => mockMethodChannel.invokeMethod<bool>("requestMicrophonePermission"),
    ).thenAnswer((_) async => true);

    final result = await audioRecorderService.requestPermission();

    expect(result, true);
    verify(() => mockMethodChannel.invokeMethod<bool>("requestMicrophonePermission"));
  });

  test('should invoke startRecorder', () async {
    when(
      () => mockMethodChannel.invokeMethod<bool>("startRecorder"),
    ).thenAnswer((_) async => true);

    final result = await audioRecorderService.startRecording();

    expect(result, true);
    verify(() => mockMethodChannel.invokeMethod<bool>("startRecorder"));
  });

  test('should invoke pauseRecorder', () async {
    when(
      () => mockMethodChannel.invokeMethod<bool>("pauseRecorder"),
    ).thenAnswer((_) async => true);

    final result = await audioRecorderService.pause();

    expect(result, true);
    verify(() => mockMethodChannel.invokeMethod<bool>("pauseRecorder"));
  });

  test('should invoke resumeRecorder', () async {
    when(
      () => mockMethodChannel.invokeMethod<bool>("resumeRecorder"),
    ).thenAnswer((_) async => true);

    final result = await audioRecorderService.resume();

    expect(result, true);
    verify(() => mockMethodChannel.invokeMethod<bool>("resumeRecorder"));
  });

  test('should invoke stopRecorder', () async {
    when(
      () => mockMethodChannel.invokeMethod<bool>("stopRecorder"),
    ).thenAnswer((_) async => true);

    final result = await audioRecorderService.stop();

    expect(result, true);
    verify(() => mockMethodChannel.invokeMethod<bool>("stopRecorder"));
  });

  test('should invoke receive pcm broadcast stream', () async {
    final data = [
      {
        "timestamp": 38.4,
        "data": [0.9, 0.38, -33],
      },
      {
        "timestamp": 15.4,
        "data": [-0.09, 1.38, -0.00033],
      },
    ];
    when(
      () => mockAudioRecorderPcmChannel.receiveBroadcastStream() as Stream<Map<String, dynamic>>,
    ).thenAnswer((_) => Stream.fromIterable(data));

    audioRecorderService.pcmStream();

    verify(() => mockAudioRecorderPcmChannel.receiveBroadcastStream());
  });
  test('should invoke receive state broadcast stream', () async {
    final data = [
      {
        "isRecording": true,
        "recordDuration": 45.6,
      },
      {
        "isRecording": false,
        "recordDuration": 456.2,
      },
    ];
    when(
      () => mockAudioRecorderStateChannel.receiveBroadcastStream()  as Stream<Map<String, dynamic>>,
    ).thenAnswer((_) => Stream.fromIterable(data));

    audioRecorderService.statusStream();

    verify(() => mockAudioRecorderStateChannel.receiveBroadcastStream());
  });
}
