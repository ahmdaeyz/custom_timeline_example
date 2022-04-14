import 'package:boxy/boxy.dart';
import 'package:collection/collection.dart';
import 'package:custom_timeline_example/time_line_arc.dart';
import 'package:custom_timeline_example/time_line_arc_painter.dart';
import 'package:custom_timeline_example/time_line_item.dart';
import 'package:flutter/material.dart';

class TimeLineDelegate extends BoxyDelegate {
  final Color activeColor;
  final Color inactiveColor;
  final List<TimeLineItem> content;
  final List<Animation<double>> connectorsAnimations;
  final double shift;

  TimeLineDelegate(
      {required this.content,
      required this.activeColor,
      required this.inactiveColor,
      this.shift = 0.0,
      required this.connectorsAnimations});

  Widget cardWidget({required int index}) => FadeTransition(
      opacity: content[index].animation!, child: content[index].widget);

  @override
  layout() {
    BoxyChild? firstCard;
    final item = inflate(cardWidget(index: 0))..layout(constraints);
    double contentHeight = 16 + item.size.height;
    item.ignore();
    for (int i = 0; i < content.length; i++) {
      if (i.isEven) {
        if (i == 0) {
          renderEvenItems(cardWidget(index: i), firstCard, contentHeight, i,
              () {
            final item = inflate(cardWidget(index: i))
              ..layout(constraints)
              ..position(const Offset(64, 64));
            firstCard = item;
            return item;
          });
        } else {
          renderEvenItems(cardWidget(index: i), firstCard, contentHeight, i,
              () {
            return inflate(cardWidget(index: i))
              ..layout(constraints)
              ..position(Offset(firstCard!.offset.dx,
                  firstCard!.offset.dy + contentHeight * i));
          });
        }
      } else {
        renderOddItems(
            cardWidget(index: i),
            firstCard,
            contentHeight,
            i,
            i == content.length - 1,
            () => inflate(cardWidget(index: i))
              ..layout(constraints)
              ..position(Offset(firstCard!.offset.dx * (1 + shift),
                  firstCard!.offset.dy + contentHeight * i)));
      }
    }

    return (firstCard!.size + const Offset(0, 25)) * content.length.toDouble();
  }

  void renderEvenItems(Widget cardWidget, BoxyChild? firstCard,
      double contentHeight, int i, BoxyChild Function() itemRenderer) {
    final connectorIndex = i * 2;
    final topLeftWidget = TimeLineArc(
      size: Size(contentHeight, contentHeight),
      angle: ArcAngle.topLeft,
      color: activeColor,
      strokeStyle: ArcStrokeStyle.solid,
      animation: connectorsAnimations[connectorIndex],
    );
    final topLeftWidgetDimmed = TimeLineArc(
      size: Size(contentHeight, contentHeight),
      angle: ArcAngle.topLeft,
      color: inactiveColor,
      strokeStyle: ArcStrokeStyle.dashed,
      animation: connectorsAnimations[connectorIndex],
    );
    final bottomLeftWidget = TimeLineArc(
      size: Size(contentHeight, contentHeight),
      angle: ArcAngle.bottomLeft,
      color: activeColor,
      leadingLineWidthFactor: 1,
      strokeStyle: ArcStrokeStyle.solid,
      animation: connectorsAnimations[connectorIndex + 1],
    );
    final bottomLeftWidgetDimmed = TimeLineArc(
      size: Size(contentHeight, contentHeight),
      angle: ArcAngle.bottomLeft,
      color: inactiveColor,
      leadingLineWidthFactor: 1,
      strokeStyle: ArcStrokeStyle.dashed,
      animation: connectorsAnimations[connectorIndex + 1],
    );
    final tl =
        inflate(content[i].isActive ? topLeftWidget : topLeftWidgetDimmed)
          ..layout(constraints);

    final currentItem = itemRenderer();

    tl.position(Offset(0, currentItem.rect.center.dy));
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
        size: Size(contentHeight, contentHeight),
        angle: ArcAngle.topRight,
        color: activeColor,
        strokeStyle: ArcStrokeStyle.solid,
        animation: connectorsAnimations[connectorIndex],
      );
      final topRightWidgetDimmed = TimeLineArc(
        size: Size(contentHeight, contentHeight),
        angle: ArcAngle.topRight,
        color: inactiveColor,
        strokeStyle: ArcStrokeStyle.dashed,
        animation: connectorsAnimations[connectorIndex],
      );
      final bottomRightWidget = TimeLineArc(
        size: Size(contentHeight, contentHeight),
        angle: ArcAngle.bottomRight,
        color: activeColor,
        strokeStyle: ArcStrokeStyle.solid,
        leadingLineWidthFactor: 1,
        animation: connectorsAnimations[connectorIndex + 1],
      );
      final bottomRightWidgetDimmed = TimeLineArc(
        size: Size(contentHeight, contentHeight),
        angle: ArcAngle.bottomRight,
        color: inactiveColor,
        strokeStyle: ArcStrokeStyle.dashed,
        leadingLineWidthFactor: 1,
        animation: connectorsAnimations[connectorIndex + 1],
      );
      final tr =
          inflate(content[i].isActive ? topRightWidget : topRightWidgetDimmed)
            ..layout(constraints);
      final currentItem = itemRenderer();
      final nextIndex = i + 1 < content.length ? i + 1 : i;
      tr.position(
          Offset(currentItem.rect.right - 54, currentItem.rect.center.dy));
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
