import 'package:audiorecorder/core/presentation/assets/app_assets.dart';
import 'package:audiorecorder/core/presentation/widgets/echo_scaffold.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_bloc.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_event.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_state.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/widgets/media_button_label.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/widgets/pcm_display.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/widgets/record_button.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/widgets/media_button.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/widgets/timer_duration.dart';
import 'package:audiorecorder/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioRecorderComponent extends StatefulWidget {
  const AudioRecorderComponent({super.key});

  @override
  State<AudioRecorderComponent> createState() => _AudioRecorderComponentState();
}

class _AudioRecorderComponentState extends State<AudioRecorderComponent> {
  AudioRecorderBloc? get bloc => !sl.isRegistered<AudioRecorderBloc>()
      ? null
      : BlocProvider.of<AudioRecorderBloc>(context);
  @override
  void initState() {
    super.initState();
    bloc?.init();
  }

  @override
  Widget build(BuildContext context) {
    return EchoScaffold(
      key: Key('audioRecorder'),
      appBar: AppBar(
        title: Text("Recording"),
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.headlineMedium,
        backgroundColor: Colors.transparent,
      ),
      body: bloc == null
          ? SizedBox.shrink()
          : BlocBuilder<AudioRecorderBloc, AudioRecorderState>(
              builder: (context, state) {
                if (state is AudioRecordStateError) {
                  return Text("Error");
                }

                return _buildBody(state as AudioRecorderStateActive);
              },
            ),
    );
  }

  Widget _buildBody(AudioRecorderStateActive state) {
    final recorderStatus = state.recorderStatus;
    return SizedBox(
      // height: 500,
      child: Column(
        children: [
          Spacer(),
          Expanded(
            flex: 2,
            child: Container(
              width: double.maxFinite,
              constraints: BoxConstraints(maxHeight: 312),
              child: PcmDisplay(pcm: state.pcm),
            ),
          ),
          SizedBox(height: 50),
          TimerDuration(
            duration: recorderStatus.recordDuration,
            isRecording: recorderStatus.isRecording,
          ),
          SizedBox(height: 35),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MediaButton(
                    assetIconPath: AppAssets.icons.plus,
                    onTap: () {
                      // TODO: use as start for now and remove later
                      bloc?.add(StartAudioRecorder());
                    },
                  ),
                  SizedBox(height: 24),
                  MediaButtonLabel("New"),
                ],
              ),
              SizedBox(width: 36),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RecordButton(
                    isPaused: !recorderStatus.isRecording,
                    onTap: () {
                      if (recorderStatus.isRecording) {
                        bloc?.add(PauseAudioRecorder());
                      } else {
                        bloc?.add(ResumeAudioRecorder());
                      }
                    },
                  ),
                  SizedBox(height: 24),
                  MediaButtonLabel(
                    recorderStatus.isRecording ? "Pause" : "Resume",
                  ),
                ],
              ),
              SizedBox(width: 36),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MediaButton(
                    assetIconPath: AppAssets.icons.stop,
                    onTap: () {
                      bloc?.add(StopAudioRecorder());
                    },
                  ),
                  SizedBox(height: 24),
                  MediaButtonLabel("Stop"),
                ],
              ),
            ],
          ),

          Spacer(),
        ],
      ),
    );
  }
}
