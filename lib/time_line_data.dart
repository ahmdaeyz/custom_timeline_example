import 'dart:ui';

import 'package:flutter/animation.dart';

class TimeLineData {
  final String label;
  final Color color;
  final bool isActive;
  final Animation<double> animation;
  TimeLineData(
      {required this.label,
      required this.color,
      this.isActive = true,
      required this.animation});
}
