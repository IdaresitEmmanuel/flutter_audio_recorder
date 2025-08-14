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
    // To make widget test on screens that navigate to this work
    bool isResitered = sl.isRegistered<AudioRecorderBloc>();
    return !isResitered
        ? AudioRecorderComponent()
        : BlocProvider<AudioRecorderBloc>(
            create: (context) => sl.get<AudioRecorderBloc>(),
            child: AudioRecorderComponent(),
          );
  }
}
