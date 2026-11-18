# Interactive Bottom Sheet

[![pub package][pub_badge]][pub_badge_link]
[![package publisher][publisher_badge]][publisher_badge_link]
[![style][style_badge]][style_link]
[![license][license_badge]][license_link]

A customizable interactive bottom sheet, which lets you interact with the screen behind it.

![Preview example](example/screenshots/example.gif "Example")

## Features

* Easy to use
* Customizable colors
* Customizable DraggableArea
* Customizable heights and widths of different parts of the sheet
* Possibility to declare snap points

## Usage

Requires Dart 3.13 or later and Flutter 3.47 or later. This fork uses the
extracted `material_ui` library; import its widgets in consuming apps as well.
`cupertino_ui` is supplied transitively by `material_ui`.

Depend on it:

```yaml
dependencies:
  interactive_bottom_sheet: ^1.0.0
 ```

Import it:

```dart
import 'package:material_ui/material_ui.dart';
import 'package:interactive_bottom_sheet/interactive_bottom_sheet.dart';
```

Example

```dart
Scaffold(
  bottomSheet: const InteractiveBottomSheet(
    options: InteractiveBottomSheetOptions(),
    child: Text(
       'Lorem ipsum dolor sit amet.'
    ),
  ),
);
```

## Customization options

```dart
Scaffold(
  bottomSheet: const InteractiveBottomSheet(
    options: InteractiveBottomSheetOptions(
      maxSize: 0.75,
      backgroundColor: Colors.green,
      snapList: [0.25, 0.5],
    ),
    draggableAreaOptions: DraggableAreaOptions(
      topBorderRadius: 10,
      height: 100,
      backgroundColor: Colors.grey,
      indicatorColor: Colors.grey,
      indicatorWidth: 50,
      indicatorHeight: 5,
      indicatorRadius: 10,
      indicatorPadding: EdgeInsets.symmetric(vertical: 16),
      title: Text('Sheet title'),
    ),
    child: Text('Lorem ipsum dolor sit amet.'),
    footer: Text('Footer'),
  ),
);
```

The fork scrolls `child` and `footer` together below the drag area. Pass ordinary
content (for example, `Text`, `Padding`, or a `Column`) rather than an unbounded
nested `ListView`. Dragging the indicator/title area resizes the sheet; scrolling
the content keeps the sheet at its current size. Content outside the sheet stays
interactive in a `Scaffold`, including with the default Material 3 theme.
The framework's persistent-sheet behavior still applies: collapsing after an
expansion resets to `initialSize`, and expansion past 70% adds a body scrim.

## Top Border Radius

To get rounded Borders at the top of the sheet (usual for iOS) on the top side of the widget, it is necessary to overwrite the `bottomSheetTheme`.

```dart
Theme(
  data: Theme.of(context).copyWith(
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent
    ),
  ),
  child: const Scaffold(
    bottomSheet: InteractiveBottomSheet(
      child: Text('Lorem ipsum dolor sit amet.'),
    ),
  ),
);
```

## Local verification

The checked-in FVM configuration selects Flutter 3.50.0.

```sh
fvm flutter pub get
fvm flutter test
fvm flutter analyze
cd example
fvm flutter test
fvm flutter analyze
```

[pub_badge]: https://img.shields.io/pub/v/interactive_bottom_sheet.svg

[pub_badge_link]: https://pub.dartlang.org/packages/interactive_bottom_sheet

[publisher_badge]: https://img.shields.io/pub/publisher/cosee_lints.svg

[publisher_badge_link]: https://pub.dev/publishers/cosee.biz/packages

[license_badge]: https://img.shields.io/github/license/cosee/cosee_lints

[license_link]: https://github.com/cosee/interactive_bottom_sheet/blob/main/LICENSE

[style_badge]: https://img.shields.io/badge/style-cosee__lints-brightgreen

[style_link]: https://pub.dev/packages/cosee_lints
