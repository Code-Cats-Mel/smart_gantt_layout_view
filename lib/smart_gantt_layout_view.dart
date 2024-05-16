library smart_gantt_layout_view;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SmartGanttLayoutView extends StatefulWidget {
  final List<GanttEventData> events;
  final Widget Function(int index) ganttCardBuilder;

  const SmartGanttLayoutView(
      {super.key, required this.events, required this.ganttCardBuilder});

  @override
  State<SmartGanttLayoutView> createState() => _SmartGanttLayoutViewState();
}

typedef GanttEventData = ({double left, double length});

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
              delegate: GanttLayoutDelegate(widget.events),
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
  final List<GanttEventData> events;

  GanttLayoutDelegate(this.events);

  @override
  void performLayout(Size size) {
    double height = size.height / 2;

    events.forEachIndexed((index, event) {
      layoutChild(
          index, BoxConstraints.tight(Size(size.width * event.length, height)));
      positionChild(
          index, Offset(size.width * event.left, index % 2 == 0 ? 0 : height));
    });
  }

  @override
  bool shouldRelayout(GanttLayoutDelegate oldDelegate) {
    return listEquals(events, oldDelegate.events);
  }
}
