import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/presentation/widgets/app_action_button.dart';
import 'package:flutter/material.dart';

class SaveOrDiscardDialog {
  /// Returns true if the positive button is clicked
  /// Returns false if the negative button is clicked
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool?>(
      context: context,
      builder: (_) => _SaveOrDiscardDialogWidget(),
    );
  }
}

class _SaveOrDiscardDialogWidget extends StatefulWidget {
  const _SaveOrDiscardDialogWidget();

  @override
  State<_SaveOrDiscardDialogWidget> createState() =>
      _SaveOrDiscardDialogWidgetState();
}

class _SaveOrDiscardDialogWidgetState
    extends State<_SaveOrDiscardDialogWidget> {
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
              "Save your recording or discard it?",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),
            Row(
              children: [
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
                const SizedBox(width: 12),
                Flexible(
                  child: AppActionButton(
                    text: "Discard",
                    borderRadius: 8,
                    background: AppColors.primary,
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Spacer(),
                Flexible(
                  child: AppActionButton(
                    text: "Save",
                    borderRadius: 8,
                    background: AppColors.secondary,
                    onPressed: () {
                      Navigator.pop(context, true);
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
