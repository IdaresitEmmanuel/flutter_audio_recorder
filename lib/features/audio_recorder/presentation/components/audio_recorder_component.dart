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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioRecorderComponent extends StatefulWidget {
  const AudioRecorderComponent({super.key});

  @override
  State<AudioRecorderComponent> createState() => _AudioRecorderComponentState();
}

class _AudioRecorderComponentState extends State<AudioRecorderComponent> {
  AudioRecorderBloc get bloc => BlocProvider.of<AudioRecorderBloc>(context);
  @override
  void initState() {
    super.initState();
    bloc.init();
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
      body: BlocBuilder<AudioRecorderBloc, AudioRecorderState>(
        builder: (context, state) {
          // return SizedBox();

          if (state is AudioRecordStateError) {
            return Text("Error");
          }

          final activeState = state as AudioRecorderStateActive;
          final recorderStatus = activeState.recorderStatus;
          return Container(
            // height:
            // 500, // Hey Gemini, this is where I adjust to check responsiveness
            child: Column(
              children: [
                Spacer(),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.maxFinite,
                    // height: double.maxFinite,
                    decoration: BoxDecoration(
                      // color: Colors.grey.withValues(alpha: .5),
                    ),
                    clipBehavior: Clip.hardEdge,
                    constraints: BoxConstraints(maxHeight: 312),

                    child: StreamBuilder(
                      stream: bloc.pcmStreamController.stream,
                      builder: (context, asyncSnapshot) {
                        return PcmDisplay(pcm: activeState.pcm);
                      },
                    ),
                  ),
                ),
                // Container(
                //   constraints: BoxConstraints(maxHeight: 312),
                //   child: WaveformDisplay(),
                // ),
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
                        MediaButton(assetIconPath: AppAssets.icons.plus),
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
                            final bloc = BlocProvider.of<AudioRecorderBloc>(
                              context,
                            );
                            if (recorderStatus.isRecording) {
                              bloc.add(PauseAudioRecorder());
                            } else {
                              bloc.add(ResumeAudioRecorder());
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
                            BlocProvider.of<AudioRecorderBloc>(
                              context,
                            ).add(StopAudioRecorder());
                          },
                        ),
                        SizedBox(height: 24),
                        MediaButtonLabel("Stop"),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AudioRecorderBloc>(
                      context,
                    ).add(StartAudioRecorder());
                  },
                  child: Text("Start"),
                ),
                Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
