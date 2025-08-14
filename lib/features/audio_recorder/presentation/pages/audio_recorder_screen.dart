import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_bloc.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/components/audio_recorder_component.dart';
import 'package:audiorecorder/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioRecorderScreen extends StatelessWidget {
  const AudioRecorderScreen({super.key});
  static const path = '/audioRecorder';
  @override
  Widget build(BuildContext context) {
    bool shouldStartRecording =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    // To make widget test on screens that navigate to this work
    bool isRegistered = sl.isRegistered<AudioRecorderBloc>();

    return !isRegistered
        ? AudioRecorderComponent(shouldStartRecording: shouldStartRecording)
        : BlocProvider<AudioRecorderBloc>(
            create: (context) => sl.get<AudioRecorderBloc>(),
            child: AudioRecorderComponent(
              shouldStartRecording: shouldStartRecording,
            ),
          );
  }
}
