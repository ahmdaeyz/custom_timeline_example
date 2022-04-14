import 'package:custom_timeline_example/custom_time_line.dart';
import 'package:custom_timeline_example/time_line_card.dart';
import 'package:custom_timeline_example/time_line_data.dart';
import 'package:custom_timeline_example/time_line_item.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom timeline',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Page(),
    );
  }
}

class Page extends StatelessWidget {
  Page({Key? key}) : super(key: key);

  final activeColor = Colors.blue[800]!;
  final inactiveColor = Colors.grey[600]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InteractiveViewer(
          constrained: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomTimeLine(
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            content: [
              TimeLineItem(
                  widget: TimeLineCard(
                      data: TimeLineData(
                          label: "First Lecture", color: activeColor))),
              TimeLineItem(
                  widget: TimeLineCard(
                      data: TimeLineData(
                          label: "First Lecture", color: activeColor))),
              TimeLineItem(
                  widget: TimeLineCard(
                      data: TimeLineData(
                          label: "First Lecture", color: activeColor))),
              TimeLineItem(
                  widget: TimeLineCard(
                      data: TimeLineData(
                          label: "First Lecture", color: activeColor))),
              TimeLineItem(
                  widget: TimeLineCard(
                    data: TimeLineData(
                        label: "First Lecture", color: inactiveColor),
                  ),
                  isActive: false),
              TimeLineItem(
                  widget: TimeLineCard(
                    data: TimeLineData(
                        label: "First Lecture", color: inactiveColor),
                  ),
                  isActive: false)
            ]),
      ),
    ));
  }
}
