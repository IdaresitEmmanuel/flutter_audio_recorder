import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_recorder/data/datasources/audio_recorder_service.dart';
import 'package:audiorecorder/features/audio_recorder/data/models/audio_recorder_pcm_model.dart';
import 'package:audiorecorder/features/audio_recorder/data/models/audio_recorder_status_model.dart';
import 'package:audiorecorder/features/audio_recorder/data/repositories/audio_recorder_repository_impl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioRecorderService extends Mock implements AudioRecorderService {}

void main() {
  final mockAudioRecorderService = MockAudioRecorderService();
  final audioRecorderRepositoryImpl = AudioRecorderRepositoryImpl(
    mockAudioRecorderService,
  );
  group('requestPermission', () {
    test('should return DataSuccess when result is true', () async {
      when(
        () => mockAudioRecorderService.requestPermission(),
      ).thenAnswer((_) async => true);

      final result = await audioRecorderRepositoryImpl.requestPermission();

      expect(result, isA<DataSuccess>());
      verify(() => mockAudioRecorderService.requestPermission());
    });
    test('should return DataFailure when result is false', () async {
      when(
        () => mockAudioRecorderService.requestPermission(),
      ).thenAnswer((_) async => false);

      final result = await audioRecorderRepositoryImpl.requestPermission();

      expect(result, isA<DataFailure>());
      verify(() => mockAudioRecorderService.requestPermission());
    });
    test('should return DataFailure on Exception', () async {
      when(
        () => mockAudioRecorderService.requestPermission(),
      ).thenThrow(PlatformException(code: 'Not Implemented'));

      final result = await audioRecorderRepositoryImpl.requestPermission();

      expect(result, isA<DataFailure>());
      verify(() => mockAudioRecorderService.requestPermission());
    });
  });
  
  group('startRecording', () {
    test('should return DataSuccess when result is true', () async {
      when(
        () => mockAudioRecorderService.startRecording(),
      ).thenAnswer((_) async => true);

      final result = await audioRecorderRepositoryImpl.startRecording();

      expect(result, isA<DataSuccess>());
      verify(() => mockAudioRecorderService.startRecording());
    });
    test('should return DataFailure when result is false', () async {
      when(
        () => mockAudioRecorderService.startRecording(),
      ).thenAnswer((_) async => false);

      final result = await audioRecorderRepositoryImpl.startRecording();

      expect(result, isA<DataFailure>());
      verify(() => mockAudioRecorderService.startRecording());
    });
    test('should return DataFailure on Exception', () async {
      when(
        () => mockAudioRecorderService.startRecording(),
      ).thenThrow(PlatformException(code: 'Not Implemented'));

      final result = await audioRecorderRepositoryImpl.startRecording();

      expect(result, isA<DataFailure>());
      verify(() => mockAudioRecorderService.startRecording());
    });
  });

  group('pause', () {
    test('should return DataSuccess when result is true', () async {
      when(
        () => mockAudioRecorderService.pause(),
      ).thenAnswer((_) async => true);

      final result = await audioRecorderRepositoryImpl.pause();

      expect(result, isA<DataSuccess>());
      verify(() => mockAudioRecorderService.pause());
    });
    test('should return DataFailure when result is false', () async {
      when(
        () => mockAudioRecorderService.pause(),
      ).thenAnswer((_) async => false);

      final result = await audioRecorderRepositoryImpl.pause();

      expect(result, isA<DataFailure>());
      verify(() => mockAudioRecorderService.pause());
    });
    test('should return DataFailure on Exception', () async {
      when(
        () => mockAudioRecorderService.pause(),
      ).thenThrow(PlatformException(code: 'Not Implemented'));

      final result = await audioRecorderRepositoryImpl.pause();

      expect(result, isA<DataFailure>());
      verify(() => mockAudioRecorderService.pause());
    });
  });

  group('resume', () {
    test('should return DataSuccess when result is true', () async {
      when(
        () => mockAudioRecorderService.resume(),
      ).thenAnswer((_) async => true);

      final result = await audioRecorderRepositoryImpl.resume();

      expect(result, isA<DataSuccess>());
      verify(() => mockAudioRecorderService.resume());
    });
    test('should return DataFailure when result is false', () async {
      when(
        () => mockAudioRecorderService.resume(),
      ).thenAnswer((_) async => false);

      final result = await audioRecorderRepositoryImpl.resume();

      expect(result, isA<DataFailure>());
      verify(() => mockAudioRecorderService.resume());
    });
    test('should return DataFailure on Exception', () async {
      when(
        () => mockAudioRecorderService.resume(),
      ).thenThrow(PlatformException(code: 'Not Implemented'));

      final result = await audioRecorderRepositoryImpl.resume();

      expect(result, isA<DataFailure>());
      verify(() => mockAudioRecorderService.resume());
    });
  });

  group('stop', () {
    test('should return DataSuccess when result is true', () async {
      when(() => mockAudioRecorderService.stop()).thenAnswer((_) async => true);

      final result = await audioRecorderRepositoryImpl.stop();

      expect(result, isA<DataSuccess>());
      verify(() => mockAudioRecorderService.stop());
    });
    test('should return DataFailure when result is false', () async {
      when(
        () => mockAudioRecorderService.stop(),
      ).thenAnswer((_) async => false);

      final result = await audioRecorderRepositoryImpl.stop();

      expect(result, isA<DataFailure>());
      verify(() => mockAudioRecorderService.stop());
    });
    test('should return DataFailure on Exception', () async {
      when(
        () => mockAudioRecorderService.stop(),
      ).thenThrow(PlatformException(code: 'Not Implemented'));

      final result = await audioRecorderRepositoryImpl.stop();

      expect(result, isA<DataFailure>());
      verify(() => mockAudioRecorderService.stop());
    });
  });

  test('should convert map to AudioRecorderPcmModel and ignore nulls', () {
    final data = [
      {
        "timestamp": 38.4,
        "data": [0.9, 0.38, -33],
      },
      null,
      {
        "timestamp": 15.4,
        "data": [-0.09, 1.38, -0.00033],
      },
    ];
    final models = [
      AudioRecorderPcmModel(
        timestamp: Duration(seconds: 38.4.toInt()),
        data: [0.9, 0.38, -33],
      ),
      AudioRecorderPcmModel(
        timestamp: Duration(seconds: 15.4.toInt()),
        data: [-0.09, 1.38, -0.00033],
      ),
    ];

    when(
      () => mockAudioRecorderService.pcmStream(),
    ).thenAnswer((_) => Stream.fromIterable(data));

    final result = audioRecorderRepositoryImpl.pcmStream();

    expectLater(result, emitsInOrder([...models, emitsDone]));

    verify(() => mockAudioRecorderService.pcmStream());
  });

  test('should convert map to AudioRecorderStatusModel and ignore nulls', () {
    final data = [
      {"isRecording": true, "recordDuration": 45.6},
      null,
      {"isRecording": false, "recordDuration": 456.2},
    ];
    final models = [
      AudioRecorderStatusModel(
        isRecording: true,
        recordDuration: Duration(seconds: 45.6.toInt()),
      ),
      AudioRecorderStatusModel(
        isRecording: false,
        recordDuration: Duration(seconds: 456.2.toInt()),
      ),
    ];

    when(
      () => mockAudioRecorderService.statusStream(),
    ).thenAnswer((_) => Stream.fromIterable(data));

    final result = audioRecorderRepositoryImpl.statusStream();

    expectLater(result, emitsInOrder([...models, emitsDone]));

    verify(() => mockAudioRecorderService.statusStream());
  });
}
