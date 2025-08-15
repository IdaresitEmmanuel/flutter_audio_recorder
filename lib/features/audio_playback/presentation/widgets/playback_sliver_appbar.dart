import 'package:audiorecorder/core/presentation/assets/app_assets.dart';
import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/presentation/theme/dimensions.dart';
import 'package:audiorecorder/core/presentation/widgets/app_icon.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

playbackSliverAppbar(
  BuildContext context, {
  double? expandedHeight,
  void Function()? onStartRecording,
}) => SliverAppBar(
  expandedHeight: expandedHeight,
  pinned: true,
  snap: false,
  surfaceTintColor: Colors.transparent,
  backgroundColor: Colors.transparent, // Color(0xffD7E0FB),
  elevation: 0,
  flexibleSpace: FlexibleSpaceBar(
    background: Container(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      height: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarGlow(
            glowColor: AppColors.primary,
            child: GestureDetector(
              key: Key('startRecording'),
              onTap: onStartRecording,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary,
                child: AppIcon(
                  AppAssets.icons.mic,
                  color: Colors.white,
                  size: Size(48, 48),
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          Text(
            "Tap to start recording",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ],
      ),
    ),
    centerTitle: false,
    stretchModes: const <StretchMode>[
      StretchMode.zoomBackground,
      StretchMode.blurBackground,
      StretchMode.fadeTitle,
    ],
    titlePadding: EdgeInsets.all(0),
    title: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCollapsed =
            constraints.biggest.height <=
            56.0 + MediaQuery.of(context).padding.top;

        return IgnorePointer(
          child: AnimatedOpacity(
            opacity: isCollapsed ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: Color(0xffD7E0FB),
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.pageMargin,
              ),
              alignment: Alignment.bottomLeft,
              child: Text(
                'Recordings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        );
      },
    ),
  ),
);
