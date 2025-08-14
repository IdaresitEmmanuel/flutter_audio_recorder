import 'dart:io';

import 'package:flutter/material.dart';

class AppInkWell extends StatelessWidget {
  const AppInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.radius,
  });
  final Widget? child;
  final void Function()? onTap;
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;
  final void Function()? onLongPress;

  /// For Android only
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _CupertinoInkWell(
            onTap: onTap,
            onTapDown: onTapDown,
            onLongPress: onLongPress,
            onTapUp: onTapUp,
            child: child,
          )
        : Material(
            color: Colors.transparent,
            child: radius != null
                ? InkResponse(
                    radius: radius,
                    onTap: onTap,
                    onTapDown: onTapDown,
                    onLongPress: onLongPress,
                    onTapUp: onTapUp,
                    child: child,
                  )
                : InkWell(
                    onTap: onTap,
                    onTapDown: onTapDown,
                    onLongPress: onLongPress,
                    onTapUp: onTapUp,
                    child: child,
                  ),
          );
  }
}

class _CupertinoInkWell extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;
  final void Function()? onLongPress;
  const _CupertinoInkWell({
    required this.child,
    required this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onLongPress,
  });

  @override
  _CupertinoInkWellState createState() => _CupertinoInkWellState();
}

class _CupertinoInkWellState extends State<_CupertinoInkWell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    if (widget.onTapDown != null) {
      widget.onTapDown!(details);
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap == null ? null : _onTapDown,
      onTapUp: widget.onTapUp ?? (widget.onTap == null ? null : _onTapUp),
      onTapCancel: widget.onTap == null ? null : _onTapCancel,
      onLongPress: widget.onLongPress,
      behavior: HitTestBehavior.deferToChild,
      child: ScaleTransition(scale: _animation, child: widget.child),
    );
  }
}
