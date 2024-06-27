import 'dart:math';

import 'package:collection/collection.dart';

typedef GanttEventData = ({double left, double length});
typedef GanttLayoutData = ({
  double left,
  double length,
  double top,
  double height
});

const double epsilon = 0.0000000000000001;

abstract interface class GanttLayoutAlgorithm {
  List<GanttEventData> get events;

  List<GanttLayoutData> getLayoutList();

  List<List<GanttEventData>> groupOverlappingEvents(
      List<GanttEventData> events) {
    final groupedEvents = <List<GanttEventData>>[];
    final sortedEvents = events.toList()
      ..sort((a, b) => a.left.compareTo(b.left));

    for (final event in sortedEvents) {
      bool added = false;
      for (final group in groupedEvents) {
        final total = group.reduce((value, element) => (
              left: min(value.left, element.left),
              length: max(value.left + value.length,
                      element.left + element.length) -
                  min(value.left, element.left),
            ));
        if (event.left + epsilon < total.left + total.length) {
          group.add(event);
          added = true;
          break;
        }
      }
      if (!added) {
        groupedEvents.add([event]);
      }
    }

    return groupedEvents;
  }
}

class GanttLayoutStackingAlgorithm extends GanttLayoutAlgorithm {
  @override
  final List<GanttEventData> events;

  GanttLayoutStackingAlgorithm(this.events);

  @override
  List<GanttLayoutData> getLayoutList() {
    List<GanttLayoutData> laidOutEvents = [];
    final groupedEvents = groupOverlappingEvents(events);

    for (final group in groupedEvents) {
      final height = 1.0 / group.length;
      final layout = group.mapIndexed((index, e) {
        return (
          left: e.left,
          length: e.length,
          top: height * index,
          height: height,
        );
      });

      laidOutEvents.addAll(layout);
    }

    return laidOutEvents;
  }
}

class GanttLayoutSmartSpacingAlgorithm extends GanttLayoutAlgorithm {
  @override
  final List<GanttEventData> events;

  GanttLayoutSmartSpacingAlgorithm(this.events);

  List<List<GanttEventData>> getLayoutListWithSmartSpacingManagement(
      List<GanttEventData> eventGroup) {
    List<List<GanttEventData>> groupedEventsByRow = [];

    for (final event in eventGroup) {
      bool added = false;
      for (final rowGroup in groupedEventsByRow) {
        final lastEvent = rowGroup.last;
        if (event.left + epsilon >= lastEvent.left + lastEvent.length) {
          rowGroup.add(event);
          added = true;
          break;
        }
      }

      if (!added) {
        groupedEventsByRow.add([event]);
      }
    }

    return groupedEventsByRow;
  }

  @override
  List<GanttLayoutData> getLayoutList() {
    List<GanttLayoutData> laidOutEvents = [];
    final overlappingEvents = groupOverlappingEvents(events);

    for (final group in overlappingEvents) {
      final groupedEvents = getLayoutListWithSmartSpacingManagement(group);
      final height = 1.0 / groupedEvents.length;

      final groupLayout = groupedEvents
          .mapIndexed((rowIndex, row) => row.map((e) {
                return (
                  left: e.left,
                  length: e.length,
                  top: height * rowIndex,
                  height: height,
                );
              }))
          .flattened
          .toList();

      laidOutEvents.addAll(groupLayout);
    }
    return laidOutEvents;
  }
}
