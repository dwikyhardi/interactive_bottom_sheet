import 'package:flutter/material.dart';

/// Options class.
class InteractiveBottomSheetOptions {
  ///  Contains all options for customization of the InteractiveBottomSheet
  const InteractiveBottomSheetOptions({
    this.backgroundColor = Colors.white,
    this.expand = false,
    this.snap = true,
    this.maxSize = 1,
    this.initialSize = 0.25,
    this.snapList = const [0.5],
  });

  /// The background color of the whole widget
  final Color backgroundColor;

  /// Decides, if the sheet snaps to the nearest position declared in snapList
  /// when if the user stops dragging
  final bool snap;

  /// Decides, if the widget should expand to fill the available space in its
  /// parent or not.
  final bool expand;

  /// The initial height of the bottom sheet, goes from 0.0 to 1.0
  final double initialSize;

  /// The maximum height of the bottom sheet
  final double maxSize;

  /// If snap is true, the bottom sheets snaps to the nearest point declared
  /// in this list when the user stops dragging
  final List<double> snapList;
}

/// Options class for the DraggableArea.
class DraggableAreaOptions {
  ///  Contains all options for customization of the DraggableArea
  const DraggableAreaOptions({
    this.topBorderRadius = 0.0,
    this.draggableAreaHeight = 50.0,
    this.draggableAreaColor = Colors.white,
    this.draggableAreaIndicatorColor = Colors.black,
    this.draggableAreaIndicatorWidth = 60.0,
    this.draggableAreaIndicatorHeight = 5.0,
    this.draggableAreaIndicatorRadius = 5.0,
    this.shadows = const [BoxShadow(color: Colors.grey, blurRadius: 1)],
  });

  /// Top Radius of the bottom sheet. To see it, a transparent background color
  /// for the bottomSheetTheme is necessary
  final double topBorderRadius;

  /// The height of the DraggableArea
  final double draggableAreaHeight;

  /// The color of the DraggableArea
  final Color draggableAreaColor;

  /// The color of the DraggableAreaIndicator
  final Color draggableAreaIndicatorColor;

  /// The width of the DraggableAreaIndicator
  final double draggableAreaIndicatorWidth;

  /// The height of the DraggableAreaIndicator
  final double draggableAreaIndicatorHeight;

  /// The top radius of the DraggableAreaIndicator
  final double draggableAreaIndicatorRadius;

  /// Defines the shadow beneath the DraggableArea
  final List<BoxShadow> shadows;
}
