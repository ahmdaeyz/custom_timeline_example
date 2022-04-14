import 'package:custom_timeline_example/time_line_arc_painter.dart';
import 'package:flutter/material.dart';

class TimeLineArc extends StatelessWidget {
  final Color color;
  final ArcAngle angle;
  final ArcStrokeStyle strokeStyle;
  final double leadingLineWidthFactor;
  final Animation<double> animation;
  final Size size;

  const TimeLineArc({Key? key,
    required this.color,
    required this.angle,
    required this.strokeStyle,
    required this.animation,
    required this.size,
    this.leadingLineWidthFactor = 1,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, widget) {
          return SizedBox(
            height: size.height,
            width: size.width,
            child: CustomPaint(
              painter: TimeLineArcPainter(
                  leadingLineWidthFactor: leadingLineWidthFactor,
                  angle: angle,
                  progress: animation.value,
                  strokeStyle: strokeStyle,
                  color: color),
            ),
          );
        });
  }
}
