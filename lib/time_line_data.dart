import 'dart:ui';


class TimeLineData {
  final String label;
  final Color color;
  final bool isActive;
  TimeLineData(
      {required this.label,
      required this.color,
      this.isActive = true,
      });
}
