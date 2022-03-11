import 'package:custom_timeline_example/custom_time_line.dart';
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
        body: SingleChildScrollView(
            child: CustomTimeLine(
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      content: [
        TimeLineItem(label: "First Lecture", color: activeColor),
        TimeLineItem(label: "Second Lecture", color: activeColor),
        TimeLineItem(label: "Third Lecture", color: activeColor),
        TimeLineItem(label: "Fourth Lecture", color: activeColor),
        TimeLineItem(
            label: "Fifth Lecture", color: inactiveColor, isActive: false),
        TimeLineItem(
            label: "Sixth Lecture", color: inactiveColor, isActive: false),
      ],
    )));
  }
}






