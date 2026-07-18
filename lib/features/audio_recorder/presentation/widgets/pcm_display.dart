import 'dart:math' as math;

import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/utils/needle_controller.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/widgets/calibrated_time_stamp.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class PcmDisplay extends StatefulWidget {
  const PcmDisplay({
    super.key,
    required this.pcm,
    required this.isRecording,
    this.needleController,
  });

  final List<AudioRecorderPcm> pcm;
  final bool isRecording;
  final NeedleController? needleController;

  @override
  State<PcmDisplay> createState() => _PcmDisplayState();
}

class _PcmDisplayState extends State<PcmDisplay> {
  late final LinkedScrollControllerGroup _scrollGroup;
  late final ScrollController _waveformScrollController;
  late final ScrollController _rulerScrollController;

  List<double> _amplitudes = [];
  int _lastPcmLength = 0;

  static const double _sampleWidth = 4.0;
  static const double _sampleGap = 2.0;
  static const double _itemWidth = _sampleWidth + _sampleGap;
  static const double _needleWidth = 3.0;

  @override
  void initState() {
    _scrollGroup = LinkedScrollControllerGroup();
    _waveformScrollController = _scrollGroup.addAndGet();
    _rulerScrollController = _scrollGroup.addAndGet();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollGroup.addOffsetChangedListener(() {
        widget.needleController?.setDuration(_needleTimestamp());
      });
    });
  }

  @override
  void dispose() {
    _waveformScrollController.dispose();
    _rulerScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PcmDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.pcm.length != _lastPcmLength) {
      _lastPcmLength = widget.pcm.length;
      _amplitudes = _reduceToAmplitudes(widget.pcm);
    }
  }

  Duration _needleTimestamp() {
    if (!_waveformScrollController.hasClients) return Duration.zero;
    if (widget.pcm.isEmpty) return Duration.zero;

    final scrollOffset = _waveformScrollController.offset;
    // For reversed List
    final needleCanvasX =
        (scrollableCanvasWidth - scrollOffset) - viewportWidth / 2;
    // For normal List
    // final needleCanvasX = scrollOffset + viewportWidth / 2;

    // Convert canvas x to bar index using the same origin the waveform uses
    final centerX = viewportWidth / 2;
    final maxHalfVisibleBars = (centerX / _itemWidth).floor();
    final isScrollable = _amplitudes.length > maxHalfVisibleBars;
    final leftPadding = isScrollable
        ? 0.0
        : (maxHalfVisibleBars - _amplitudes.length) * _itemWidth +
              _sampleWidth / 2;

    final barIndex = ((needleCanvasX - leftPadding) / _itemWidth).floor();
    final clampedIndex = barIndex.clamp(0, widget.pcm.length - 1);

    return widget.pcm[clampedIndex].timestamp;
  }

  List<double> _reduceToAmplitudes(List<AudioRecorderPcm> pcm) {
    if (pcm.isEmpty) return [];

    // A fixed reference value representing "loud enough to hit the top".
    // RMS of a full-scale sine wave on a [-1, 1] signal is ~0.707.
    // A lower value fits the UI better like (0.3)
    const double ceiling = 0.3;

    return pcm.map((chunk) {
      if (chunk.data.isEmpty) return 0.0;
      final sumOfSquares = chunk.data.fold(
        0.0,
        (sum, sample) => sum + (sample * sample),
      );
      final rms = math.sqrt(sumOfSquares / chunk.data.length);
      // Clamp to [0, 1] so a very loud spike doesn't exceed the canvas height
      return (rms / ceiling).clamp(0.0, 1.0);
    }).toList();
  }

  // Canvas grows to fit all bars. Needle is drawn at the center.
  //User can scroll left to review the full recording.
  // Pad the left side so the first bar isn't flush against the edge
  double get scrollableCanvasWidth => math.max(
    totalBarsWidth + emptySpaceRight + emptySpaceLeft,
    viewportWidth,
  );

  double get viewportWidth => MediaQuery.of(context).size.width;
  double get totalBarsWidth => _amplitudes.length * _itemWidth;
  double get emptySpaceLeft =>
      _amplitudes.length < ((viewportWidth / 2) / _itemWidth).floor()
      ? (viewportWidth / 2) - totalBarsWidth
      : 0;
  double get emptySpaceRight => viewportWidth / 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final viewportWidth = constraints.maxWidth;
              final viewportHeight = constraints.maxHeight;
              if (widget.isRecording) {
                //********  Recording mode ******** //
                // MARK: Fixed waveform
                // Canvas is fixed to viewport size. The painter draws the bars from
                // center to left using the most recent amplitudes while the right side
                // of the canvas is empty
                return CustomPaint(
                  size: Size(viewportWidth, viewportHeight),
                  painter: _WaveformPainter(
                    amplitudes: _amplitudes,
                    isRecording: true,
                    viewportWidth: viewportWidth,
                    itemWidth: _itemWidth,
                    sampleWidth: _sampleWidth,
                    needleWidth: _needleWidth,
                  ),
                );
              } else {
                // ********** Paused / scroll mode ********** //
                // MARK: Scrollable waveform

                return Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _waveformScrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      reverse: true,
                      child: CustomPaint(
                        size: Size(scrollableCanvasWidth, viewportHeight),
                        painter: _WaveformPainter(
                          amplitudes: _amplitudes,
                          isRecording: false,
                          viewportWidth: viewportWidth,
                          itemWidth: _itemWidth,
                          sampleWidth: _sampleWidth,
                          needleWidth: _needleWidth,
                        ),
                      ),
                    ),

                    // MARK: Fixed center needle for scroll mode
                    Positioned(
                      left: viewportWidth / 2 - _needleWidth / 2,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        width: _needleWidth,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        // MARK: CALIBRATED TIMESTAMP
        // ********* Calibrated timestamp ********* //
        SizedBox(
          height: 16,
          child: CalibratedTimeStamp(
            pcm: widget.pcm,
            scrollController: _rulerScrollController,
            isRecording: widget.isRecording,
            scrollCanvasWidth: scrollableCanvasWidth,
            scrollLeftPadding: emptySpaceLeft,
            waveItemWidth: _itemWidth,
          ),
        ),
      ],
    );
  }
}

// MARK: Waveform painter
class _WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final bool isRecording;
  final double viewportWidth;
  final double itemWidth;
  final double sampleWidth;
  final double needleWidth;
  _WaveformPainter({
    required this.amplitudes,
    required this.isRecording,
    required this.viewportWidth,
    required this.itemWidth,
    required this.sampleWidth,
    required this.needleWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sampleWidth
      ..strokeCap = StrokeCap.round;

    final needlePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = needleWidth
      ..strokeCap = StrokeCap.round;

    final height = size.height;
    final centerY = height / 2;
    final minBarHalfHeight = height * 0.005;
    final maxBarHalfHeight = height * 0.45;

    if (isRecording) {
      _paintRecording(
        canvas,
        centerY,
        minBarHalfHeight,
        maxBarHalfHeight,
        barPaint,
        needlePaint,
        height,
      );
    } else {
      _paintScrollable(
        canvas,
        centerY,
        minBarHalfHeight,
        maxBarHalfHeight,
        barPaint,
        needlePaint,
        height,
      );
    }
  }

  void _paintRecording(
    Canvas canvas,
    double centerY,
    double minBarHalfHeight,
    double maxBarHalfHeight,
    Paint barPaint,
    Paint needlePaint,
    double height,
  ) {
    // Needle is fixed at the horizontal center of the viewport
    final needleX = viewportWidth / 2;

    // How many bars fit between the left edge and the needle
    final maxVisibleBars = (needleX / itemWidth).floor();

    // Take only the most recent N amplitudes (the tail of the list)
    final visibleCount = math.min(amplitudes.length, maxVisibleBars);
    final startIndex = amplitudes.length - visibleCount;

    // Draw bars left-to-right, but positioned so the LAST bar sits just
    // left of the needle and earlier bars extend further left.
    //
    // Bar at (amplitudes.length - 1) → x = needleX - itemWidth
    // Bar at (amplitudes.length - 2) → x = needleX - 2 * itemWidth
    // ...and so on.
    for (int i = startIndex; i < amplitudes.length; i++) {
      // Distance from the end: 0 = most recent, 1 = second most recent, ...
      final distanceFromNeedle = amplitudes.length - 1 - i;
      final x =
          needleX - (distanceFromNeedle + 1) * itemWidth + sampleWidth / 2;

      if (x < 0) continue; // clip anything that went off-screen

      final halfHeight = minBarHalfHeight + amplitudes[i] * maxBarHalfHeight;

      canvas.drawLine(
        Offset(x, centerY - halfHeight),
        Offset(x, centerY + halfHeight),
        barPaint,
      );
    }

    // Fixed center needle
    canvas.drawLine(Offset(needleX, 0), Offset(needleX, height), needlePaint);
  }

  void _paintScrollable(
    Canvas canvas,
    double centerY,
    double minBarHalfHeight,
    double maxBarHalfHeight,
    Paint barPaint,
    Paint needlePaint,
    double height,
  ) {
    // bars may be too few to fille half the view port, so we need to fill up
    // the left side with empty space to keep them in line with the needle

    final centerX = viewportWidth / 2;
    final maxHalfVisibleBars = (centerX / itemWidth).floor();
    bool isScrollable = amplitudes.length > maxHalfVisibleBars;
    final leftPadding =
        ((maxHalfVisibleBars - amplitudes.length) * itemWidth +
        sampleWidth / 2);

    // Bars are laid out left-to-right from leftPadding, oldest to newest
    for (int i = 0; i < amplitudes.length; i++) {
      final x =
          (isScrollable ? 0 : leftPadding) + i * itemWidth + sampleWidth / 2;
      final halfHeight = minBarHalfHeight + amplitudes[i] * maxBarHalfHeight;

      canvas.drawLine(
        Offset(x, centerY - halfHeight),
        Offset(x, centerY + halfHeight),
        barPaint,
      );
    }

    // Fixed center needle is drawn over the scrollable so it always appears
    // in the same place on the screen
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) {
    return oldDelegate.amplitudes.length != amplitudes.length ||
        oldDelegate.isRecording != isRecording;
  }
}
