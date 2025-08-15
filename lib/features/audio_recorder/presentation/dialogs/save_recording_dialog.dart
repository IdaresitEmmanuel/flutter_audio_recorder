import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/presentation/widgets/app_action_button.dart';
import 'package:flutter/material.dart';

class SaveRecordingDialog {
  /// Returns true if the positive button is clicked
  /// Returns false if the negative button is clicked
  static Future<String?> show(
    BuildContext context, {
    required String defaultText,
  }) {
    return showDialog<String?>(
      context: context,
      builder: (_) => _SaveRecordingDialogWidget(defaultText: defaultText),
    );
  }
}

class _SaveRecordingDialogWidget extends StatefulWidget {
  const _SaveRecordingDialogWidget({required this.defaultText});
  final String defaultText;

  @override
  State<_SaveRecordingDialogWidget> createState() =>
      _SaveRecordingDialogWidgetState();
}

class _SaveRecordingDialogWidgetState
    extends State<_SaveRecordingDialogWidget> {
  late final TextEditingController textController;
  FocusNode focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    textController = TextEditingController(text: widget.defaultText);

    super.initState();
    textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: textController.text.length,
    );
    focusNode.requestFocus();
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
            Row(
              children: [
                Text(
                  "Save Recording",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Form(
              key: formKey,
              child: TextFormField(
                controller: textController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hint: Text(
                    "Record name",
                    style: TextStyle(color: AppColors.grey400),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Field cannot be empty"
                    : null,
              ),
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
                    text: "Save",
                    borderRadius: 8,
                    background: AppColors.secondary,
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.pop(context, textController.text);
                      }
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
