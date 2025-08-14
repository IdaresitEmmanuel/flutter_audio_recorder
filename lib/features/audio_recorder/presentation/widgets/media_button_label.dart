import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:flutter/material.dart';

class MediaButtonLabel extends StatelessWidget {
  const MediaButtonLabel(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      ),
    );
  }
}
