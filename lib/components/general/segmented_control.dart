import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

const EdgeInsets _horizontalPadding = EdgeInsets.symmetric(horizontal: 16.0);

class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({Key? key, required this.children, this.selectionIndex, this.onSegmentChosen, this.horizontalPadding = _horizontalPadding}) : super(key: key);


  final Map<T, Widget> children;

  /// Currently selected item index. Make sure to pass the value
  /// from [onSegmentChosen] to see the selection state.
  final T? selectionIndex;

  /// The callback to use when a segmented item is chosen
  final ValueChanged<T>? onSegmentChosen;

  final EdgeInsets horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return MaterialSegmentedControl(
      children: children,
      selectionIndex: selectionIndex,
      onSegmentChosen: onSegmentChosen,
      horizontalPadding: horizontalPadding,
      borderColor: Theme.of(context).colorScheme.primary,
      selectedColor: Theme.of(context).colorScheme.primary,
      unselectedColor: Theme.of(context).colorScheme.surface,
      borderRadius: 12,
      verticalOffset: 9,
    );
  }
}
