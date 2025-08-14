import 'package:audiorecorder/core/presentation/widgets/app_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.iconAssetLocation, {
    super.key,
    this.size,
    this.onTap,
    this.color,
    this.fit = BoxFit.contain,
    this.onTapUp,
  });
  final String iconAssetLocation;
  final Size? size;
  final Color? color;
  final void Function()? onTap;
  final BoxFit fit;
  final void Function(TapUpDetails)? onTapUp;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AppInkWell(
        onTap: onTap,
        onTapUp: onTapUp,
        child: SvgPicture.asset(
          iconAssetLocation,
          height: size?.height ?? 24,
          width: size?.width ?? 24,
          fit: fit,
          colorFilter: ColorFilter.mode(
              color ?? Theme.of(context).iconTheme.color!, BlendMode.srcIn),
        ),
      ),
    );
  }
}
