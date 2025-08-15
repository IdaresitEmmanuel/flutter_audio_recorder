import 'package:audiorecorder/core/presentation/router/routes.dart';
import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_bloc.dart';
import 'package:audiorecorder/features/audio_playback/presentation/pages/audio_playback_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioPlaybackBloc extends Mock implements AudioPlaybackBloc {}

void main() {
  
  testWidgets(
    'should render without bugs and tap record to navigate to record page',
    (tester) async {

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: Routes.onGenerateRoute,
          home: AudioPlaybackScreen(),
        ),
      );

      final audioPlaybackScaffold = find.byKey(ValueKey('audioPlayback'));
      final startRecordingButton = find.byKey(ValueKey('startRecording'));
      expect(audioPlaybackScaffold, findsOneWidget);
      expect(startRecordingButton, findsOneWidget);

      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(startRecordingButton);

      await tester.pumpAndSettle();

      final audioRecorderScaffold = find.byKey(ValueKey('audioRecorder'));

      expect(audioRecorderScaffold, findsOneWidget);

    },
  );
}
