library smart_gantt_layout_view;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'gantt_layout_algorithm.dart';

enum GanttLayoutAlgorithmType { stacking, smartSpacing }

class SmartGanttLayoutView extends StatefulWidget {
  final List<GanttEventData> events;
  final Widget Function(int index) ganttCardBuilder;

  final GanttLayoutAlgorithmType algorithmType;

  const SmartGanttLayoutView(
      {super.key,
      required this.events,
      required this.ganttCardBuilder,
      this.algorithmType = GanttLayoutAlgorithmType.smartSpacing});

  @override
  State<SmartGanttLayoutView> createState() => _SmartGanttLayoutViewState();
}

class _SmartGanttLayoutViewState extends State<SmartGanttLayoutView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        if (widget.events.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: CustomMultiChildLayout(
              delegate:
                  GanttLayoutDelegate(widget.events, widget.algorithmType),
              children: [
                ...widget.events.mapIndexed((index, e) => LayoutId(
                      id: index,
                      child: widget.ganttCardBuilder(index),
                    )),
              ],
            ),
          ),
      ],
    );
  }
}

class GanttLayoutDelegate extends MultiChildLayoutDelegate {
  final GanttLayoutAlgorithm ganttLayoutAlgorithm;

  GanttLayoutDelegate(
      List<GanttEventData> events, GanttLayoutAlgorithmType algorithmType)
      : ganttLayoutAlgorithm =
            algorithmType == GanttLayoutAlgorithmType.stacking
                ? GanttLayoutStackingAlgorithm(events)
                : GanttLayoutSmartSpacingAlgorithm(events);

  @override
  void performLayout(Size size) {
    final eventsLayout = ganttLayoutAlgorithm.getLayoutList();

    eventsLayout.forEachIndexed((index, event) {
      layoutChild(
          index,
          BoxConstraints.tight(
              Size(size.width * event.length, size.height * event.height)));
      positionChild(
          index, Offset(size.width * event.left, size.height * event.top));
    });
  }

  @override
  bool shouldRelayout(GanttLayoutDelegate oldDelegate) {
    return listEquals(
        ganttLayoutAlgorithm.events, oldDelegate.ganttLayoutAlgorithm.events);
  }
}
