import 'package:boxy/boxy.dart';
import 'package:custom_timeline_example/time_line_data.dart';
import 'package:custom_timeline_example/time_line_delegate.dart';
import 'package:custom_timeline_example/time_line_item.dart';
import 'package:flutter/material.dart';

class CustomTimeLine extends StatefulWidget {
  final List<TimeLineItem> content;
  final Color activeColor;
  final Color inactiveColor;

  const CustomTimeLine(
      {Key? key,
      required this.content,
      required this.activeColor,
      required this.inactiveColor})
      : super(key: key);

  @override
  State<CustomTimeLine> createState() => _CustomTimeLineState();
}

class _CustomTimeLineState extends State<CustomTimeLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  final scaleTween = Tween<double>(begin: 0.0, end: 1.0);
  List<TimeLineData> animatedContent = [];
  List<Animation<double>> connectorsAnimations = [];

  @override
  void initState() {
    super.initState();
    final numOfWidgets = widget.content.length + widget.content.length * 2 - 2;
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: (numOfWidgets) * 300));
    final interval = 1.0 / numOfWidgets;
    for (int i = 0; i < numOfWidgets; i++) {
      final double begin = i - 1 < 0 ? 0 : (i - 1) * interval;
      final double end = i == 0 ? interval : i * interval;
      final itemAnimation = scaleTween.animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(
            begin,
            end,
            curve: Curves.ease,
          ),
        ),
      );
      if (i % 3 == 0) {
        final item = widget.content[i~/3];
        animatedContent.add(TimeLineData(
            label: item.label,
            color: item.color,
            isActive: item.isActive,
            animation: itemAnimation));
      } else {
        connectorsAnimations.add(itemAnimation);
      }
    }
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBoxy(
        delegate: TimeLineDelegate(
            content: animatedContent,
            activeColor: widget.activeColor,
            connectorsAnimations: connectorsAnimations,
            inactiveColor: widget.inactiveColor));
  }
}
