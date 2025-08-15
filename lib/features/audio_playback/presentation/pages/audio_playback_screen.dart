import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_bloc.dart';
import 'package:audiorecorder/features/audio_playback/presentation/component/audio_playback_component.dart';
import 'package:audiorecorder/service_locator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioPlaybackScreen extends StatelessWidget {
  const AudioPlaybackScreen({super.key});
  static const path = '/audioPlayback';
  @override
  Widget build(BuildContext context) {
    // To make widget test on screens that navigate to this work
    bool isResitered = sl.isRegistered<AudioPlaybackBloc>();
    return !isResitered
        ? AudioPlaybackComponent()
        : BlocProvider<AudioPlaybackBloc>(
            create: (context) => sl.get<AudioPlaybackBloc>(),
            child: AudioPlaybackComponent(),
          );
  }
}
