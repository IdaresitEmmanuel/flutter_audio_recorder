import 'dart:io';

import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/presentation/theme/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppActionButton extends StatelessWidget {
  const AppActionButton({
    super.key,
    this.child,
    this.text,
    this.icon,
    this.height,
    this.width,
    this.onPressed,
    this.isHollow = false,
    this.isOdd = false,
    this.isLoading = false,
    this.loadingSize,
    this.defaultLoading = false,
    this.borderRadius,
    this.background,
  }) : assert(
         (text != null && child == null) || (child != null && text == null),
       );
  final String? text;
  final Widget? icon;
  final Widget? child;
  final double? width;
  final double? height;
  final void Function()? onPressed;
  final bool isHollow;
  final bool isOdd;
  final bool isLoading;
  final double? loadingSize;
  final bool defaultLoading;
  final double? borderRadius;
  final Color? background;

  onSafeTap() {
    if (!isLoading && onPressed != null) {
      onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? SizedBox(
            height: height ?? 42,
            width: width,
            child: Container(
              decoration: BoxDecoration(
                border: isHollow
                    ? Border.all(
                        color: isOdd
                            ? _oddColor(context)
                            : Theme.of(context).primaryColor,
                      )
                    : null,
                borderRadius: BorderRadius.circular(borderRadius ?? 42 / 2),
              ),
              child: CupertinoButton(
                padding: EdgeInsets.all(0),
                onPressed: onSafeTap,
                color: isHollow
                    ? Colors.transparent
                    : isOdd
                    ? _oddColor(context)
                    : background ?? Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppDimensions.defaultButtonHeight / 2,
                ),
                child: SizedBox(
                  width: double.maxFinite,
                  child: Center(
                    child: isLoading
                        ? _loader(context)
                        : (child ?? _title(context)),
                  ),
                ),
              ),
            ),
          )
        : ElevatedButton(
            onPressed: onSafeTap,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              overlayColor: isHollow
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.5)
                  : isOdd
                  ? _oddColor(context)
                  : Colors.red,
              backgroundColor: isHollow
                  ? Colors.transparent
                  : isOdd
                  ? _oddColor(context)
                  : background ?? Theme.of(context).primaryColor,
              fixedSize: Size(width ?? double.maxFinite, height ?? 42),
              padding: EdgeInsets.all(0),
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                side: isHollow
                    ? BorderSide(
                        color: isOdd
                            ? _oddColor(context)
                            : Theme.of(context).primaryColor,
                      )
                    : BorderSide.none,
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppDimensions.defaultButtonHeight / 2,
                ),
              ),
            ),
            child: isLoading ? _loader(context) : (child ?? _title(context)),
          );
  }

  Widget _loader(BuildContext context) {
    return defaultLoading
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _text("Loading", context),
              const SizedBox(width: 4),
              // LoadingAnimationWidget.waveDots(
              //   color: Colors.black,
              //   size: 30,
              // )
            ],
          )
        : SizedBox(
            height: loadingSize ?? 30,
            width: loadingSize ?? 30,
            child: CircularProgressIndicator(color: Colors.black),
          );
  }

  Color _oddColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.grey400
        : AppColors.grey600;
  }

  Widget _title(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [_text(text!, context), if (icon != null) icon!],
    );
  }

  Widget _text(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: !isHollow && !isOdd ? Colors.white : AppColors.grey700,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
