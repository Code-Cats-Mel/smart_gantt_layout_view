import 'package:flutter_test/flutter_test.dart';
import 'package:smart_gantt_layout_view/gantt_layout_algorithm.dart';

void main() {
  test('not overlapping', () {
    List<GanttEventData> events = [
      (left: 0, length: 0.2),
      (left: 0.3, length: 0.2),
      (left: 0.6, length: 0.2),
    ];

    GanttLayoutAlgorithm ganttLayoutAlgorithm =
        GanttLayoutStackingAlgorithm(events);
    final layoutList = ganttLayoutAlgorithm.getLayoutList();

    expect(layoutList, [
      (left: 0, length: 0.2, top: 0.0, height: 1.0),
      (left: 0.3, length: 0.2, top: 0.0, height: 1.0),
      (left: 0.6, length: 0.2, top: 0.0, height: 1.0),
    ]);
  });

  test('two events overlapping', () {
    List<GanttEventData> events = [
      (left: 0, length: 0.2),
      (left: 0.1, length: 0.2),
      (left: 0.5, length: 0.2),
    ];

    GanttLayoutAlgorithm ganttLayoutAlgorithm =
        GanttLayoutStackingAlgorithm(events);
    final layoutList = ganttLayoutAlgorithm.getLayoutList();

    expect(layoutList, [
      (left: 0, length: 0.2, top: 0, height: 0.5),
      (left: 0.1, length: 0.2, top: 0.5, height: 0.5),
      (left: 0.5, length: 0.2, top: 0, height: 1.0),
    ]);
  });

  test('three events overlapping, but only two overlap in same time', () {
    List<GanttEventData> events = [
      (left: 0.0, length: 0.2),
      (left: 0.1, length: 0.2),
      (left: 0.6, length: 0.2),
    ];

    GanttLayoutAlgorithm ganttLayoutAlgorithm =
        GanttLayoutStackingAlgorithm(events);
    final layoutList = ganttLayoutAlgorithm.getLayoutList();

    expect(layoutList, [
      (left: 0.0, length: 0.2, top: 0.0, height: 1 / 2.0),
      (left: 0.1, length: 0.2, top: 1 / 2.0, height: 1 / 2.0),
      (left: 0.6, length: 0.2, top: 0.0, height: 1),
    ]);
  });

  test('get overlappingEvents', () {
    List<GanttEventData> events = [
      (left: 0, length: 0.2),
      (left: 0.1, length: 0.2),
      (left: 0.5, length: 0.2),
    ];

    GanttLayoutAlgorithm ganttLayoutAlgorithm =
        GanttLayoutStackingAlgorithm(events);
    final overlappingEvents =
        ganttLayoutAlgorithm.groupOverlappingEvents(events);

    expect(overlappingEvents, [
      [
        (left: 0, length: 0.2),
        (left: 0.1, length: 0.2),
      ],
      [(left: 0.5, length: 0.2)]
    ]);
  });

  test('get no overlapping events', () {
    List<GanttEventData> events = [
      (left: 0, length: 0.2),
      (left: 0.2, length: 0.2),
      (left: 0.5, length: 0.2),
    ];

    GanttLayoutAlgorithm ganttLayoutAlgorithm =
        GanttLayoutStackingAlgorithm(events);
    final overlappingEvents =
        ganttLayoutAlgorithm.groupOverlappingEvents(events);

    expect(overlappingEvents, [
      [(left: 0, length: 0.2), (left: 0.2, length: 0.2)],
      [(left: 0.5, length: 0.2)]
    ]);
  });

  test('get smartLayout', () {
    List<GanttEventData> events = [
      (left: 0.0, length: 0.2),
      (left: 0.1, length: 0.5),
      (left: 0.3, length: 0.2),
      (left: 0.3, length: 0.2),
      (left: 0.7, length: 0.2),
    ];

    GanttLayoutSmartSpacingAlgorithm ganttLayoutAlgorithm =
        GanttLayoutSmartSpacingAlgorithm(events);
    final layout = ganttLayoutAlgorithm.getLayoutList();

    expect(layout, [
      (left: 0.0, length: 0.2, top: 0.0, height: 1.0 / 3),
      (left: 0.3, length: 0.2, top: 0.0, height: 1.0 / 3),
      (left: 0.1, length: 0.5, top: 1.0 / 3, height: 1.0 / 3),
      (left: 0.3, length: 0.2, top: 2.0 / 3, height: 1.0 / 3),
      (left: 0.7, length: 0.2, top: 0.0, height: 1.0),
    ]);
  });

  test('get smartLayout - back to back should not overlapping', () {
    List<GanttEventData> events = [
      (left: 0, length: 0.2),
      (left: 0.1, length: 0.2),
      (left: 0.3, length: 0.2),
      (left: 0.3, length: 0.2),
      (left: 0.3, length: 0.2),
    ];

    GanttLayoutSmartSpacingAlgorithm ganttLayoutAlgorithm =
        GanttLayoutSmartSpacingAlgorithm(events);
    final layout = ganttLayoutAlgorithm.getLayoutList();

    expect(layout, [
      (left: 0.0, length: 0.2, top: 0.0, height: 1.0 / 2),
      (left: 0.1, length: 0.2, top: 1.0 / 2, height: 1.0 / 2),
      (left: 0.3, length: 0.2, top: 0.0 / 3, height: 1.0 / 3),
      (left: 0.3, length: 0.2, top: 1.0 / 3, height: 1.0 / 3),
      (left: 0.3, length: 0.2, top: 2.0 / 3, height: 1.0 / 3),
    ]);
  });

  test('get smartLayout - more', () {
    List<GanttEventData> events = [
      (left: 0, length: 0.2),
      (left: 0.1, length: 0.5),
      (left: 0.1, length: 0.2),
      (left: 0.3, length: 0.2),
      (left: 0.3, length: 0.2),
      (left: 0.3, length: 0.2),
      (left: 0.7, length: 0.05),
      (left: 0.7, length: 0.2),
      (left: 0.8, length: 0.05),
      (left: 0.8, length: 0.3),
    ];

    GanttLayoutSmartSpacingAlgorithm ganttLayoutAlgorithm =
        GanttLayoutSmartSpacingAlgorithm(events);
    final layout = ganttLayoutAlgorithm.getLayoutList();

    expect(layout, [
      (left: 0.0, length: 0.2, top: 0.0, height: 1.0 / 4),
      (left: 0.3, length: 0.2, top: 0.0, height: 1.0 / 4),
      (left: 0.1, length: 0.5, top: 1.0 / 4, height: 1.0 / 4),
      (left: 0.1, length: 0.2, top: 2.0 / 4, height: 1.0 / 4),
      (left: 0.3, length: 0.2, top: 2.0 / 4, height: 1.0 / 4),
      (left: 0.3, length: 0.2, top: 3.0 / 4, height: 1.0 / 4),
      (left: 0.7, length: 0.05, top: 0.0 / 3, height: 1.0 / 3),
      (left: 0.8, length: 0.05, top: 0.0 / 3, height: 1.0 / 3),
      (left: 0.7, length: 0.2, top: 1.0 / 3, height: 1.0 / 3),
      (left: 0.8, length: 0.3, top: 2.0 / 3, height: 1.0 / 3),
    ]);
  });
}
