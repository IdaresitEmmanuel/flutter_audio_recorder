import 'dart:ui' as ui;

import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/util/helper_functions.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:flutter/material.dart';

class CalibratedTimeStamp extends StatelessWidget {
  const CalibratedTimeStamp({super.key, required this.pcm});
  final List<AudioRecorderPcm> pcm;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CalibratedTimestampPainter(pcm: pcm),
      child: SizedBox.expand(),
    );
  }
}

class _CalibratedTimestampPainter extends CustomPainter {
  final List<AudioRecorderPcm> pcm;
  _CalibratedTimestampPainter({required this.pcm});
  @override
  void paint(Canvas canvas, Size size) {
    var painter = Paint()
      ..color = AppColors.grey900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    var height = size.height;
    var width = size.width;

    final defaultPcm = AudioRecorderPcm(timestamp: Duration.zero, data: []);

    _drawHorizontalLine(canvas, width, painter);

    _drawCalibration(
      canvas: canvas,
      painter: painter,
      width: width,
      height: height,

      lastPcm: pcm.isEmpty ? defaultPcm : pcm.last,
    );
  }

  _drawHorizontalLine(Canvas canvas, double width, Paint painter) {
    var polygonPath = Path();
    polygonPath.moveTo(0, 0);
    polygonPath.lineTo(width, 0);
    canvas.drawPath(polygonPath, painter);
  }

  _drawCalibration({
    required Canvas canvas,
    required Paint painter,
    required double width,
    required double height,

    required AudioRecorderPcm lastPcm,
  }) {
    double calWidth = 16;
    double milliSecondCal = (lastPcm.timestamp.inMilliseconds * calWidth) / 250;
    int noOfCal = ((width) / calWidth).toInt();

    for (var i = 0; i < noOfCal + milliSecondCal / calWidth; i++) {
      final double x = ((i) * (calWidth) + (width / 2)) - milliSecondCal;
      bool fullHeight = i % 4 == 0;
      var polygonPath = Path();
      polygonPath.moveTo(x, 0);
      polygonPath.lineTo(x, fullHeight ? height : height / 2);
      canvas.drawPath(polygonPath, painter);

      if (fullHeight) {
        final currentTimestamp = Duration(milliseconds: i * 250);
        _drawCountDown(
          canvas,
          Offset(x, height / 2),
          calculateAndFormatDuration(currentTimestamp, false),
        );
      }
    }
  }

  _drawCountDown(Canvas canvas, Offset offset, String countDown) {
    var paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(textAlign: TextAlign.center, fontSize: 9),
    );
    paragraphBuilder.pushStyle(ui.TextStyle(color: ui.Color(0xff5C5C5C)));
    paragraphBuilder.addText(countDown);
    var paragraph = paragraphBuilder.build();
    paragraph.layout(ui.ParagraphConstraints(width: 30));
    var adjustedCenter = Offset(offset.dx, offset.dy);
    canvas.drawParagraph(paragraph, adjustedCenter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
