import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_playback_repository.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/seek_to_position.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioPlaybackRepository extends Mock
    implements AudioPlaybackRepository {}

void main() {
  final mockAudioPlaybackRepository = MockAudioPlaybackRepository();
  final seekToPositionUsecase = SeekToPositionUsecase(
    mockAudioPlaybackRepository,
  );

  test('should call seek(position) and return dataState', () async {
    final position = Duration.zero;
    when(
      () => mockAudioPlaybackRepository.seek(position),
    ).thenAnswer((_) async => DataSuccess(unit));

    final result = await seekToPositionUsecase(params: position);

    expect(result, isA<DataSuccess>());
  });
}
