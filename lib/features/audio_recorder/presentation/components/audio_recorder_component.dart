import 'package:audiorecorder/core/presentation/assets/app_assets.dart';
import 'package:audiorecorder/core/presentation/router/app_router.dart';
import 'package:audiorecorder/core/presentation/widgets/echo_scaffold.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_bloc.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_event.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_state.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/dialogs/save_or_discard_dialog.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/dialogs/save_recording_dialog.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/widgets/media_button_label.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/widgets/pcm_display.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/widgets/record_button.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/widgets/media_button.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/widgets/timer_duration.dart';
import 'package:audiorecorder/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioRecorderComponent extends StatefulWidget {
  const AudioRecorderComponent({super.key, required this.shouldStartRecording});
  final bool shouldStartRecording;
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
    if (widget.shouldStartRecording) {
      bloc?.add(StartAudioRecorder());
    }
  }

  @override
  Widget build(BuildContext context) {
    return EchoScaffold(
      key: Key('audioRecorder'),
      resizeToAvoidBottomInset: false,
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, __) async {
        bloc?.add(PauseAudioRecorder());
        if (didPop) return;
        bool? shouldSave = await SaveOrDiscardDialog.show(context);
        if (shouldSave == null) return;
        if (shouldSave) {
          bloc?.add(SaveAudioRecording());
        } else {
          bloc?.add(DiscardAudioRecording());
        }
        if (context.mounted) {
          // ignore: use_build_context_synchronously
          AppRouter.pop(context);
        }
      },
      child: SizedBox(
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
                      onTap: () {},
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
                      onTap: () async {
                        bloc?.add(PauseAudioRecorder());
                        String? title = await SaveRecordingDialog.show(
                          context,
                          defaultText:
                              "Record ${DateTime.now().toIso8601String()}",
                        );

                        if (title == null) {
                          bloc?.add(ResumeAudioRecorder());
                          return;
                        }
                        bloc?.add(StopAudioRecorder());
                        bloc?.add(SaveAudioRecording(title: title));
                        if (context.mounted) {
                          // ignore: use_build_context_synchronously
                          AppRouter.pop(context);
                        }
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
      ),
    );
  }
}
