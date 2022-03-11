import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

enum ArcAngle { topLeft, topRight, bottomLeft, bottomRight }
enum ArcStrokeStyle { solid, dashed }

class TimeLineArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final ArcAngle angle;
  final ArcStrokeStyle strokeStyle;
  final double leadingLineWidthFactor;

  TimeLineArcPainter(
      {this.color = Colors.white,
      this.angle = ArcAngle.bottomLeft,
      this.strokeStyle = ArcStrokeStyle.solid,
      this.progress = 1,
      this.leadingLineWidthFactor = 0});
  double degToRad(num deg) => deg * (math.pi / 180.0);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final rectWidth = size.width;
    final rectHeight = size.height;
    const rectX = 0.0;
    const rectY = 0.0;
    final rect = Rect.fromLTWH(rectX, rectY, rectWidth, rectHeight);
    Path path = Path();
    final leadingLineStartPoint = angle.leadingLineStart(
        rectStart: const Point(rectX, rectY),
        size: Size(rectWidth, rectHeight));
    final arcShouldBeDrawnFirst =
        angle == ArcAngle.bottomLeft || angle == ArcAngle.bottomRight;

    if (arcShouldBeDrawnFirst) {
      if (progress <= 0.5) {
        final localProgress = progress / 0.5;
        createArc(path, rect, localProgress);
      } else {
        final localProgress = progress / 0.5;
        createLine(path, leadingLineStartPoint, rectWidth,
            progress: localProgress);
        createArc(path, rect, 1);
      }
    } else {
      if (progress <= 0.50) {
        final localProgress = progress / 0.5;
        createLine(path, leadingLineStartPoint, rectWidth,
            progress: localProgress);
      } else {
        final localProgress = progress / 0.5;
        createLine(path, leadingLineStartPoint, rectWidth);
        createArc(path, rect, localProgress);
      }
    }
    drawDashedPath(path, canvas, paint);
  }

  void createArc(Path path, Rect rect, double localProgress) {
    path.arcTo(rect, degToRad(angle.startAngle),
        degToRad((angle == ArcAngle.topLeft ? -90 : 90) * localProgress), true);
  }

  void createLine(
      Path path, Point<double> leadingLineStartPoint, double rectWidth,
      {double progress = 1}) {
    path.moveTo(leadingLineStartPoint.x, leadingLineStartPoint.y);

    final endOfLeadingLineDirection =
        angle == ArcAngle.bottomRight || angle == ArcAngle.topRight ? -1 : 1;

    path.lineTo(
        (leadingLineStartPoint.x +
            (endOfLeadingLineDirection *
                    ((rectWidth / 2) * leadingLineWidthFactor)) *
                progress),
        leadingLineStartPoint.y);
  }

  void drawDashedPath(Path path, Canvas canvas, Paint paint) {
    const dashLength = 11.0;
    const dashGapLength = 9.0;
    Path pathToBeDrawn;
    switch (strokeStyle) {
      case ArcStrokeStyle.solid:
        pathToBeDrawn = path;
        break;
      case ArcStrokeStyle.dashed:
        final dashedPathProperties = DashedPathProperties(
          path: Path(),
          dashLength: dashLength,
          dashGapLength: dashGapLength,
        );

        pathToBeDrawn = _getDashedPath(
            path, dashLength, dashGapLength, dashedPathProperties);
        break;
    }

    canvas.drawPath(pathToBeDrawn, paint);
  }

  @override
  bool shouldRepaint(TimeLineArcPainter oldDelegate) =>
      oldDelegate.progress != progress;

  Path _getDashedPath(
    Path originalPath,
    double dashLength,
    double dashGapLength,
    DashedPathProperties dashedPathProperties,
  ) {
    final metricsIterator = originalPath.computeMetrics().iterator;
    while (metricsIterator.moveNext()) {
      final metric = metricsIterator.current;
      dashedPathProperties.extractedPathLength = 0.0;
      while (dashedPathProperties.extractedPathLength < metric.length) {
        if (dashedPathProperties.addDashNext) {
          dashedPathProperties.addDash(metric, dashLength);
        } else {
          dashedPathProperties.addDashGap(metric, dashGapLength);
        }
      }
    }
    return dashedPathProperties.path;
  }
}

extension ArcAngleInDegrees on ArcAngle {
  double get startAngle {
    switch (this) {
      case ArcAngle.topLeft:
        return 270;
      case ArcAngle.topRight:
        return 270;
      case ArcAngle.bottomLeft:
        return 90;
      case ArcAngle.bottomRight:
        return 0;
    }
  }

  Point<double> leadingLineStart(
      {Point<double> rectStart = const Point(0, 0), required Size size}) {
    switch (this) {
      case ArcAngle.topLeft:
        return Point(rectStart.x + size.width / 2, rectStart.y);
      case ArcAngle.topRight:
        return Point(rectStart.x + size.width / 2, rectStart.y);
      case ArcAngle.bottomLeft:
        return Point(rectStart.x + size.width / 2, rectStart.y + size.height);
      case ArcAngle.bottomRight:
        return Point(rectStart.x + size.width / 2, rectStart.y + size.height);
    }
  }
}

class DashedPathProperties {
  double extractedPathLength;
  Path path;

  final double _dashLength;
  double _remainingDashLength;
  double _remainingDashGapLength;
  bool _previousWasDash;

  DashedPathProperties({
    required this.path,
    required double dashLength,
    required double dashGapLength,
  })  : assert(dashLength > 0.0, 'dashLength must be > 0.0'),
        assert(dashGapLength > 0.0, 'dashGapLength must be > 0.0'),
        _dashLength = dashLength,
        _remainingDashLength = dashLength,
        _remainingDashGapLength = dashGapLength,
        _previousWasDash = false,
        extractedPathLength = 0.0;

  bool get addDashNext {
    if (!_previousWasDash || _remainingDashLength != _dashLength) {
      return true;
    }
    return false;
  }

  void addDash(PathMetric metric, double dashLength) {
    // Calculate lengths (actual + available)
    final end = _calculateLength(metric, _remainingDashLength);
    final availableEnd = _calculateLength(metric, dashLength);
    // Add path
    final pathSegment = metric.extractPath(extractedPathLength, end);
    path.addPath(pathSegment, Offset.zero);
    // Update
    final delta = _remainingDashLength - (end - extractedPathLength);
    _remainingDashLength = _updateRemainingLength(
      delta: delta,
      end: end,
      availableEnd: availableEnd,
      initialLength: dashLength,
    );
    extractedPathLength = end;
    _previousWasDash = true;
  }

  void addDashGap(PathMetric metric, double dashGapLength) {
    // Calculate lengths (actual + available)
    final end = _calculateLength(metric, _remainingDashGapLength);
    final availableEnd = _calculateLength(metric, dashGapLength);
    // Move path's end point
    Tangent tangent = metric.getTangentForOffset(end)!;
    path.moveTo(tangent.position.dx, tangent.position.dy);
    // Update
    final delta = end - extractedPathLength;
    _remainingDashGapLength = _updateRemainingLength(
      delta: delta,
      end: end,
      availableEnd: availableEnd,
      initialLength: dashGapLength,
    );
    extractedPathLength = end;
    _previousWasDash = false;
  }

  double _calculateLength(PathMetric metric, double addedLength) {
    return math.min(extractedPathLength + addedLength, metric.length);
  }

  double _updateRemainingLength({
    required double delta,
    required double end,
    required double availableEnd,
    required double initialLength,
  }) {
    return (delta > 0 && availableEnd == end) ? delta : initialLength;
  }
}
