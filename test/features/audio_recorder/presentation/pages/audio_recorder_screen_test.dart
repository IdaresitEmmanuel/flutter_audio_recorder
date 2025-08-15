import 'package:audiorecorder/features/audio_recorder/presentation/pages/audio_recorder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should render without bugs', (tester) async {
    await tester.pumpWidget(
        MaterialApp(
          home: AudioRecorderScreen(),
        ),
      );

      final audioRecorderScaffold = find.byKey(ValueKey('audioRecorder'));

      expect(audioRecorderScaffold, findsOneWidget);
  });
}
