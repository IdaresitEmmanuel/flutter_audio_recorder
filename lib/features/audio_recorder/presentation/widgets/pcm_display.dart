import 'dart:math' as math;

import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:flutter/material.dart';

class PcmDisplay extends StatelessWidget {
  const PcmDisplay({super.key, required this.pcm});
  final List<AudioRecorderPcm> pcm;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WaveformPainter(dataList: pcm),
      child: SizedBox.expand(),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<AudioRecorderPcm> dataList;

  _WaveformPainter({required this.dataList});

  @override
  void paint(Canvas canvas, Size size) {
    var painter = Paint()
      ..color = AppColors.primary.withValues(alpha: .6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    var height = size.height;
    var width = size.width / 2;

    double sampleWidth = 4.0;
    int numberOfSamples = (width / sampleWidth).toInt();

    var filteredList = dataList
        .map((d) => d.data.map((dd) => dd.abs()).reduce(math.max))
        .toList();

    var visibleSamples = filteredList.sublist(
      math.max(0, filteredList.length - numberOfSamples),
    );

    _drawWavePolygons(
      canvas,
      painter,
      width,
      sampleWidth,
      height,
      visibleSamples,
    );
    _drawNeedle(width: size.width, height: height, canvas: canvas);
  }

  _drawWavePolygons(
    Canvas canvas,
    Paint painter,
    double width,
    double sampleWidth,
    double height,
    List<double> visibleSamples,
  ) {
    final double maxSampleValue = .09;
    for (int i = 0; i < visibleSamples.length; i++) {
      final double x = width - (i * sampleWidth);

      // Normalize the sample value and scale it to the canvas height
      final double normalizedY = maxSampleValue > 0
          ? visibleSamples.reversed.toList()[i] / maxSampleValue
          : 0;

      final double barHeight = (normalizedY * height / 2).abs();

      final double topY = (height / 2) - (barHeight / 2);
      final double bottomY = (height / 2) + (barHeight / 2);
      final double topYWithLimit = topY < (height * .1) ? (height * .1) : topY;
      final double bottomYWithLimit =
          (bottomY > (height * .9) || topYWithLimit < 0
          ? (height * .9)
          : bottomY);

      var polygonPath = Path();
      polygonPath.moveTo(x, topYWithLimit);
      polygonPath.lineTo(x, bottomYWithLimit);
      canvas.drawPath(polygonPath, painter);
    }
  }

  _drawNeedle({
    required double width,
    required double height,
    required Canvas canvas,
  }) {
    var painter = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    var polygonPath = Path();
    polygonPath.moveTo(width / 2, 0);
    polygonPath.lineTo(width / 2, height);
    canvas.drawPath(polygonPath, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
