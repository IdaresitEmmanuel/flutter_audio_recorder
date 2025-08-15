import 'package:audiorecorder/core/presentation/assets/app_assets.dart';
import 'package:audiorecorder/core/presentation/router/app_router.dart';
import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/presentation/widgets/app_icon.dart';
import 'package:audiorecorder/core/presentation/widgets/app_popup_menu.dart';
import 'package:audiorecorder/core/presentation/widgets/echo_scaffold.dart';
import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_bloc.dart';
import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_event.dart';
import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_state.dart';
import 'package:audiorecorder/features/audio_playback/presentation/widgets/audio_list_item.dart';
import 'package:audiorecorder/features/audio_playback/presentation/widgets/persistent_divider.dart';
import 'package:audiorecorder/features/audio_playback/presentation/widgets/playback_sliver_appbar.dart';
import 'package:audiorecorder/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioPlaybackComponent extends StatefulWidget {
  const AudioPlaybackComponent({super.key});

  @override
  State<AudioPlaybackComponent> createState() => _AudioPlaybackComponentState();
}

class _AudioPlaybackComponentState extends State<AudioPlaybackComponent> {
  AudioPlaybackBloc? get bloc => !sl.isRegistered<AudioPlaybackBloc>()
      ? null
      : BlocProvider.of<AudioPlaybackBloc>(context);

  final ScrollController _scrollController = ScrollController();
  bool _isAppBarCollapsed = false;
  double expandedHeight = 300.0;
  double fabSize = 82.0;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    bloc?.add(GetAudioFiles());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double collapseOffset = expandedHeight - kToolbarHeight;
    final bool collapsed =
        _scrollController.hasClients &&
        _scrollController.offset >= collapseOffset / 1.5; // prev remove 1.5

    if (_isAppBarCollapsed != collapsed) {
      setState(() {
        _isAppBarCollapsed = collapsed;
      });
    }
  }

  _startRecording() async {
    await AppRouter.goToAudioRecorderScreen(context, argument: true);
    bloc?.add(GetAudioFiles());
    await Future.delayed(Duration(seconds: 1), () {
      if (context.mounted) {
        bloc?.add(GetAudioFiles());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return EchoScaffold(
      key: Key('audioPlayback'),
      floatingActionButton: !_isAppBarCollapsed
          ? null
          : SizedBox(
              height: fabSize,
              width: fabSize,
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: _startRecording,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(30),
                  ),
                  backgroundColor: AppColors.primary,
                  child: AppIcon(
                    AppAssets.icons.mic,
                    color: Colors.white,
                    size: Size(30, 30),
                  ),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          playbackSliverAppbar(
            context,
            expandedHeight: expandedHeight,
            onStartRecording: _startRecording,
          ),
          SliverPersistentHeader(delegate: PersistentDivider(height: 3)),
          SliverToBoxAdapter(child: SizedBox(height: 40)),
          if (bloc != null)
            BlocBuilder<AudioPlaybackBloc, AudioPlaybackState>(
              builder: (context, state) {
                if (state is AudioPlaybackLoading) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,

                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                final stateDone = state as AudioPlaybackDone;

                if (stateDone.fileList.isEmpty) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: Center(child: Text("No Files")),
                    ),
                  );
                }

                return SliverList.separated(
                  itemCount: stateDone.fileList.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 12);
                  },
                  itemBuilder: (context, index) {
                    final audioFile = stateDone.fileList[index];
                    return AudioListItem(
                      audioFile: audioFile,
                      onLongPress: (details) {
                        AppPopupMenu.show<String>(
                          context: context,
                          tapPosition: details.globalPosition,
                          onMenuItemSelected: (item) {
                            if (item == "delete") {
                              bloc?.add(DeleteAudioFile(audioFile: audioFile));
                            }
                          },
                          menuItems: [
                            ShieldedPopupMenuItem<String>(
                              title: "Delete",
                              value: "delete",
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          SliverToBoxAdapter(child: SizedBox(height: fabSize)),
        ],
      ),
    );
  }
}
