import 'dart:ui' as ui;

import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/util/helper_functions.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:flutter/material.dart';

class CalibratedTimeStamp extends StatelessWidget {
  const CalibratedTimeStamp({
    super.key,
    required this.pcm,
    required this.isRecording,
    required this.scrollCanvasWidth,
    required this.scrollController,
    required this.scrollLeftPadding,
    required this.waveItemWidth,
  });

  final List<AudioRecorderPcm> pcm;
  final bool isRecording;
  final double scrollCanvasWidth;
  final ScrollController scrollController;
  final double scrollLeftPadding;

  /// _sampleWidth(4) + _sampleGap
  final double waveItemWidth;

  @override
  Widget build(BuildContext context) {
    if (isRecording) {
      return CustomPaint(
        painter: _CalibratedTimestampPainter(
          pcm: pcm,
          isRecording: isRecording,
          scrollCanvasWidth: scrollCanvasWidth,
          scrollLeftPadding: scrollLeftPadding,
          waveItemWidth: waveItemWidth,
        ),
        child: SizedBox.expand(),
      );
    } else {
      return SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        reverse: true,
        clipBehavior: .none,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(scrollCanvasWidth, double.maxFinite),
              painter: _CalibratedTimestampPainter(
                pcm: pcm,
                isRecording: isRecording,
                scrollCanvasWidth: scrollCanvasWidth,
                scrollLeftPadding: scrollLeftPadding,
                waveItemWidth: waveItemWidth,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _CalibratedTimestampPainter extends CustomPainter {
  final List<AudioRecorderPcm> pcm;
  final bool isRecording;
  final double scrollCanvasWidth;
  final double scrollLeftPadding;
  final double waveItemWidth;

  _CalibratedTimestampPainter({
    required this.pcm,
    required this.isRecording,
    required this.scrollCanvasWidth,
    required this.scrollLeftPadding,
    required this.waveItemWidth,
  });

  double _getTickSpacing() {
    double itemWidth = waveItemWidth; // _sampleWidth(4) + _sampleGap(3)
    // tickSpacingPx = how many pixels represent 250ms worth of bars
    // 250ms of audio = however many PCM chunks fit in 250ms * itemWidth each.
    // Since pcm chunks arrive at a fixed rate
    // pixelsPerMs = totalBarsWidth / lastPcm.inMilliseconds
    // tickSpacingPx = 250 * pixelsPerMs
    // When no data yet, fall back to 16px (same as recording mode).
    final int totalMs = pcm.isEmpty ? 0 : pcm.last.timestamp.inMilliseconds;
    final int totalBars = pcm.length;
    // ── CHANGED: tick interval in pixels derived from actual data rate§
    final double tickSpacingPx = totalMs > 0
        ? (totalBars * itemWidth) / totalMs * 250
        : 16.0;
    return tickSpacingPx;
  }

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
    if (isRecording) {
      _paintRecording(
        canvas: canvas,
        painter: painter,
        width: width,
        height: height,

        lastPcm: pcm.isEmpty ? defaultPcm : pcm.last,
      );
    } else {
      _paintScrollable(
        canvas: canvas,
        painter: painter,
        width: scrollCanvasWidth,
        height: height,

        lastPcm: pcm.isEmpty ? defaultPcm : pcm.last,
      );
    }
  }

  _drawHorizontalLine(Canvas canvas, double width, Paint painter) {
    var polygonPath = Path();
    polygonPath.moveTo(0, 0);
    polygonPath.lineTo(width, 0);
    canvas.drawPath(polygonPath, painter);
  }

  _paintRecording({
    required Canvas canvas,
    required Paint painter,
    required double width,
    required double height,

    required AudioRecorderPcm lastPcm,
  }) {
    double tickSpacing = _getTickSpacing();
    // this is just total time in pixels
    double milliSecondCal =
        lastPcm.timestamp.inMilliseconds * (tickSpacing / 250);

    int noOfCal = ((width) / tickSpacing).toInt();

    for (var i = 0; i < (noOfCal / 2) + milliSecondCal / tickSpacing; i++) {
      final double x = ((i) * (tickSpacing) + (width / 2)) - milliSecondCal;
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

  _paintScrollable({
    required Canvas canvas,
    required Paint painter,
    required double width,
    required double height,
    required AudioRecorderPcm lastPcm,
  }) {
    // Since the waveform is drawn from the right to the left,
    // this is the gap before is touches the left edge of the canvas
    final double origin = scrollLeftPadding;

    // tickSpacingPx = how many pixels represent 250ms worth of bars
    final double tickSpacingPx = _getTickSpacing();

    final int noOfTicks = ((width - origin) / tickSpacingPx).toInt() + 1;

    for (var i = 0; i < noOfTicks; i++) {
      // ── CHANGED: x starts from origin using tickSpacingPx
      final double x = origin + (i * tickSpacingPx);
      if (x > width) break;

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
