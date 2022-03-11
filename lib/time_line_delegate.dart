import 'package:boxy/boxy.dart';
import 'package:custom_timeline_example/time_line_arc.dart';
import 'package:custom_timeline_example/time_line_arc_painter.dart';
import 'package:custom_timeline_example/time_line_card.dart';
import 'package:custom_timeline_example/time_line_data.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'package:collection/collection.dart';

class TimeLineDelegate extends BoxyDelegate {
  final Color activeColor;
  final Color inactiveColor;
  final List<TimeLineData> content;
  final List<Animation<double>> connectorsAnimations;

  TimeLineDelegate(
      {required this.content,
      required this.activeColor,
      required this.inactiveColor,
      required this.connectorsAnimations});

  Widget get topLeftWidget => SizedBox(
        height: 65,
        width: 65,
        child: CustomPaint(
          painter: TimeLineArcPainter(
              leadingLineWidthFactor: 1,
              angle: ArcAngle.topLeft,
              color: activeColor),
        ),
      );

  Widget get bottomLeftWidget => SizedBox(
        height: 65,
        width: 65,
        child: CustomPaint(
          painter: TimeLineArcPainter(
              leadingLineWidthFactor: 2,
              angle: ArcAngle.bottomLeft,
              color: activeColor),
        ),
      );

  Widget get topRightWidget => SizedBox(
        height: 65,
        width: 65,
        child: CustomPaint(
          painter: TimeLineArcPainter(
              leadingLineWidthFactor: 2,
              angle: ArcAngle.topRight,
              color: activeColor),
        ),
      );

  Widget get bottomRightWidget => SizedBox(
        height: 65,
        width: 65,
        child: CustomPaint(
          painter: TimeLineArcPainter(
              leadingLineWidthFactor: 2,
              angle: ArcAngle.bottomRight,
              color: activeColor),
        ),
      );

  Widget get topLeftWidgetDimmed => SizedBox(
        height: 65,
        width: 65,
        child: CustomPaint(
          painter: TimeLineArcPainter(
              leadingLineWidthFactor: 1,
              angle: ArcAngle.topLeft,
              strokeStyle: ArcStrokeStyle.dashed,
              color: inactiveColor),
        ),
      );

  Widget get bottomLeftWidgetDimmed => SizedBox(
        height: 65,
        width: 65,
        child: CustomPaint(
          painter: TimeLineArcPainter(
              leadingLineWidthFactor: 2,
              angle: ArcAngle.bottomLeft,
              strokeStyle: ArcStrokeStyle.dashed,
              color: inactiveColor),
        ),
      );

  Widget get topRightWidgetDimmed => SizedBox(
        height: 65,
        width: 65,
        child: CustomPaint(
          painter: TimeLineArcPainter(
              leadingLineWidthFactor: 2,
              angle: ArcAngle.topRight,
              strokeStyle: ArcStrokeStyle.dashed,
              color: inactiveColor),
        ),
      );

  Widget get bottomRightWidgetDimmed => SizedBox(
        height: 65,
        width: 65,
        child: CustomPaint(
          painter: TimeLineArcPainter(
              leadingLineWidthFactor: 2,
              strokeStyle: ArcStrokeStyle.dashed,
              angle: ArcAngle.bottomRight,
              color: inactiveColor),
        ),
      );

  Widget cardWidget(TimeLineData data) => TimeLineCard(data: data);
  @override
  layout() {
    BoxyChild? firstCard;
    double contentHeight = 16;
    for (int i = 0; i < content.length; i++) {
      if (i.isEven) {
        if (i == 0) {
          renderEvenItems(cardWidget(content[i]), firstCard, contentHeight, i,
              () {
            final item = inflate(cardWidget(content[i]))
              ..layout(constraints)
              ..position(const Offset(64, 64));
            firstCard = item;
            contentHeight += item.size.height;
            return item;
          });
        } else {
          renderEvenItems(cardWidget(content[i]), firstCard, contentHeight, i,
              () {
            return inflate(cardWidget(content[i]))
              ..layout(constraints)
              ..position(Offset(firstCard!.offset.dx,
                  firstCard!.offset.dy + contentHeight * i));
          });
        }
      } else {
        renderOddItems(
            cardWidget(content[i]),
            firstCard,
            contentHeight,
            i,
            i == content.length - 1,
            () => inflate(cardWidget(content[i]))
              ..layout(constraints)
              ..position(Offset(firstCard!.offset.dx * 1.5,
                  firstCard!.offset.dy + contentHeight * i)));
      }
    }

    return (firstCard!.size + const Offset(0, 25)) * content.length.toDouble();
  }

  void renderEvenItems(Widget cardWidget, BoxyChild? firstCard,
      double contentHeight, int i, BoxyChild Function() itemRenderer) {
    final connectorIndex = i * 2;
    final topLeftWidget = TimeLineArc(
      angle: ArcAngle.topLeft,
      color: activeColor,
      strokeStyle: ArcStrokeStyle.solid,
      animation: connectorsAnimations[connectorIndex],
    );
    final topLeftWidgetDimmed = TimeLineArc(
      angle: ArcAngle.topLeft,
      color: inactiveColor,
      strokeStyle: ArcStrokeStyle.dashed,
      animation: connectorsAnimations[connectorIndex],
    );
    final bottomLeftWidget = TimeLineArc(
      angle: ArcAngle.bottomLeft,
      color: activeColor,
      leadingLineWidthFactor: 2,
      strokeStyle: ArcStrokeStyle.solid,
      animation: connectorsAnimations[connectorIndex + 1],
    );
    final bottomLeftWidgetDimmed = TimeLineArc(
      angle: ArcAngle.bottomLeft,
      color: inactiveColor,
      leadingLineWidthFactor: 2,
      strokeStyle: ArcStrokeStyle.dashed,
      animation: connectorsAnimations[connectorIndex + 1],
    );
    final tl =
        inflate(content[i].isActive ? topLeftWidget : topLeftWidgetDimmed)
          ..layout(constraints);

    final currentItem = itemRenderer();

    tl.position(Offset(16, currentItem.rect.center.dy));
    inflate(content[i].isActive ? bottomLeftWidget : bottomLeftWidgetDimmed)
      ..layout(constraints)
      ..position(tl.offset);
  }

  void renderOddItems(
      Widget cardWidget,
      BoxyChild? firstCard,
      double contentHeight,
      int i,
      bool isLastItem,
      BoxyChild Function() itemRenderer) {
    if (!isLastItem) {
      final connectorIndex = i * 2;
      final topRightWidget = TimeLineArc(
        angle: ArcAngle.topRight,
        color: activeColor,
        strokeStyle: ArcStrokeStyle.solid,
        animation: connectorsAnimations[connectorIndex],
      );
      final topRightWidgetDimmed = TimeLineArc(
        angle: ArcAngle.topRight,
        color: inactiveColor,
        strokeStyle: ArcStrokeStyle.dashed,
        animation: connectorsAnimations[connectorIndex],
      );
      final bottomRightWidget = TimeLineArc(
        angle: ArcAngle.bottomRight,
        color: activeColor,
        strokeStyle: ArcStrokeStyle.solid,
        leadingLineWidthFactor: 2,
        animation: connectorsAnimations[connectorIndex + 1],
      );
      final bottomRightWidgetDimmed = TimeLineArc(
        angle: ArcAngle.bottomRight,
        color: inactiveColor,
        strokeStyle: ArcStrokeStyle.dashed,
        leadingLineWidthFactor: 2,
        animation: connectorsAnimations[connectorIndex + 1],
      );
      final tr =
          inflate(content[i].isActive ? topRightWidget : topRightWidgetDimmed)
            ..layout(constraints);
      final currentItem = itemRenderer();
      final nextIndex = i + 1 < content.length ? i + 1 : i;
      tr.position(
          Offset(currentItem.rect.right - 8, currentItem.rect.center.dy));
      inflate(content[nextIndex].isActive
          ? bottomRightWidget
          : bottomRightWidgetDimmed)
        ..layout(constraints)
        ..position(tr.offset);
    } else {
      itemRenderer();
    }
  }

  @override
  shouldRelayout(TimeLineDelegate oldDelegate) {
    const orderedEquality = DeepCollectionEquality();
    return oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        !orderedEquality.equals(oldDelegate.content, content);
  }
}
