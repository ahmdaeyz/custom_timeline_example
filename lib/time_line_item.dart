import 'package:flutter/material.dart';

class TimeLineItem {
  final Widget widget;
  final bool isActive;
  final Animation<double>? animation;

  TimeLineItem({required this.widget, this.isActive = true, this.animation});
}
