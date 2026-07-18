import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/presentation/widgets/app_action_button.dart';
import 'package:flutter/material.dart';

class RestartRecordingDialog {
  /// Returns true TO DISCARD AND RESTART
  /// Returns false TO SAVE AND RESTART
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool?>(
      context: context,
      builder: (_) => _RestartRecordingDialogWidget(),
    );
  }
}

class _RestartRecordingDialogWidget extends StatefulWidget {
  const _RestartRecordingDialogWidget();

  @override
  State<_RestartRecordingDialogWidget> createState() =>
      _RestartRecordingDialogWidgetState();
}

class _RestartRecordingDialogWidgetState
    extends State<_RestartRecordingDialogWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Theme.of(context).brightness == Brightness.dark
              ? Border.all(color: AppColors.grey800)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Save and restart or restart your recording?",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: AppActionButton(
                    text: "Discard & Restart",
                    borderRadius: 8,
                    background: AppColors.primary,
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: AppActionButton(
                    text: "Save & Restart",
                    borderRadius: 8,
                    background: AppColors.secondary,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: AppActionButton(
                    text: "Cancel",
                    borderRadius: 8,
                    isHollow: true,
                    isOdd: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
