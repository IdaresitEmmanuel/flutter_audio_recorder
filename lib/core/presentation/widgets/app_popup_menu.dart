import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/presentation/theme/dimensions.dart';
import 'package:audiorecorder/core/presentation/widgets/app_ink_well.dart';
import 'package:audiorecorder/core/presentation/widgets/gradient_box_border.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class AppPopupMenu<T> {
  static OverlayEntry? overlay;

  static show<T>({
    required BuildContext context,
    required Offset tapPosition,
    required void Function(T) onMenuItemSelected,
    void Function()? onClose,
    required List<ShieldedPopupMenuItem<T>> menuItems,
  }) {
    _PopupController popupController = _PopupController();
    overlay = OverlayEntry(
      builder: (BuildContext context) => GestureDetector(
        onTap: () {
          popupController.animateAndCloseDialog();
        },
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                left: tapPosition.dx,
                top: tapPosition.dy,
                child: _PopupMenuWidget<T>(
                  popupController: popupController,
                  origin: tapPosition,
                  onMenuItemSelected: onMenuItemSelected,
                  menuItems: menuItems,
                  hideOptionBubble: () {
                    overlay?.remove();
                    if (onClose != null) {
                      onClose();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    Overlay.of(context).insert(overlay!);
  }
}

class _PopupMenuWidget<T> extends StatefulWidget {
  const _PopupMenuWidget({
    required this.onMenuItemSelected,
    required this.hideOptionBubble,
    required this.menuItems,
    required this.origin,
    required this.popupController,
  });

  final void Function(T menuItem) onMenuItemSelected;
  final void Function() hideOptionBubble;
  final List<ShieldedPopupMenuItem<T>> menuItems;
  final Offset origin;
  final _PopupController popupController;

  @override
  State<_PopupMenuWidget<T>> createState() => __OptionsBubbleState<T>();
}

class __OptionsBubbleState<T> extends State<_PopupMenuWidget<T>>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation scaleAnimation;
  late Animation opacityAnimation;
  Duration animationDuration = const Duration(milliseconds: 200);
  Duration animationReverseDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    setUpAnimation();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      startAnimation();
    });
    widget.popupController.setCloseCallback(closePopup);
  }

  setUpAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
      reverseDuration: animationReverseDuration,
    );

    scaleAnimation = Tween(begin: .5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  startAnimation() {
    _animationController.forward();
  }

  stopAnimation() {
    _animationController.stop();
  }

  closePopup() async {
    _animationController.reverse();
    await Future.delayed(animationReverseDuration);
    widget.hideOptionBubble();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scaleByVector3(
              vector.Vector3(scaleAnimation.value, scaleAnimation.value, 1),
            ),
          child: Opacity(
            // opacity: opacityAnimation.value,
            opacity: 1,

            child: SizedBox(
              width: 240,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: BoxConstraints(minWidth: 200),
                    padding: EdgeInsets.all(AppDimensions.pageMargin / 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      border: GradientBoxBorder(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffB2B2B2).withValues(alpha: .3),
                            Color(0xffB2B2B2).withValues(alpha: .05),
                          ],
                        ),
                      ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.defaultBorderRadius,
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      itemBuilder: (_, index) {
                        return _listTile(widget.menuItems[index]);
                      },
                      separatorBuilder: (_, __) =>
                          SizedBox(height: 20), // previous 10
                      itemCount: widget.menuItems.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _listTile(ShieldedPopupMenuItem<T> menuItem) {
    return AppInkWell(
      onTap: () {
        widget.onMenuItemSelected(menuItem.value);
        closePopup();
      },
      child: Container(
        padding: EdgeInsets.all(AppDimensions.pageMargin / 2),
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Text(
                menuItem.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.grey700
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (menuItem.hasBadge)
              Container(
                height: 5,
                width: 5,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}

class ShieldedPopupMenuItem<T> {
  final String? iconAssetLocation;
  final String title;
  final T value;
  final bool hasBadge;

  ShieldedPopupMenuItem({
    this.iconAssetLocation,
    required this.title,
    required this.value,
    this.hasBadge = false,
  });
}

class _PopupController {
  late final void Function() animateAndCloseDialog;
  setCloseCallback(void Function() callback) {
    animateAndCloseDialog = callback;
  }
}
