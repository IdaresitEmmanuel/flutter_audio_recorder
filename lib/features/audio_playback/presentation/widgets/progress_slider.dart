import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:flutter/material.dart';

class PlayerSlider extends StatefulWidget {
  const PlayerSlider({
    super.key,
    this.min = 0,
    this.max = 10,
    this.value = 5,
    this.seek,
  });
  final double min;
  final double max;
  final double value;
  final void Function(double position)? seek;
  @override
  State<PlayerSlider> createState() => _PlayerSliderState();
}

class _PlayerSliderState extends State<PlayerSlider> {
  double _trimValue(double value) {
    if (value > widget.max) widget.max;
    if (value < widget.min) widget.min;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SliderTheme(
        data: SliderThemeData(
          trackShape: CustomTrackShape(),
          trackHeight: 4,
          thumbColor: AppColors.primary,
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.grey300,

          padding: EdgeInsets.all(0),
        ),
        child: Slider(
          value: _trimValue(widget.value),
          min: widget.min,
          max: widget.max,
          onChanged: widget.seek,
        ),
      ),
    );
  }
}

// contains the shape of the player slider information
class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
