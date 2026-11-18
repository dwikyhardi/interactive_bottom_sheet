import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_bottom_sheet/interactive_bottom_sheet.dart';
import 'package:interactive_bottom_sheet/src/indicator_widget.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders fork defaults in the modern Material Scaffold', (
    tester,
  ) async {
    await _pumpSheet(
      tester,
      const InteractiveBottomSheet(child: Text('Content')),
    );

    final context = tester.element(find.byType(InteractiveBottomSheet));
    expect(Theme.of(context).useMaterial3, isTrue);
    expect(_controller(tester).size, 0.25);
    expect(tester.getSize(find.byType(DraggableScrollableSheet)).height, 150);
    expect(tester.getSize(find.byType(SingleChildScrollView)).height, 50);
    expect(find.text('Content'), findsOneWidget);

    final indicator = tester.widget<Container>(_indicator);
    expect(indicator.constraints!.maxWidth, 40);
    expect(indicator.constraints!.maxHeight, 5);
    expect(indicator.margin, const EdgeInsets.symmetric(vertical: 16));
    final decoration = indicator.decoration! as BoxDecoration;
    expect(decoration.color, Colors.black);
    expect(decoration.borderRadius, const BorderRadius.all(Radius.circular(5)));
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders title, footer, and custom sheet and indicator options', (
    tester,
  ) async {
    const area = DraggableAreaOptions(
      topBorderRadius: 24,
      height: 100,
      backgroundColor: Colors.blue,
      indicatorColor: Colors.red,
      indicatorWidth: 64,
      indicatorHeight: 8,
      indicatorRadius: 4,
      indicatorPadding: EdgeInsets.all(12),
      shadows: [BoxShadow(color: Colors.green, blurRadius: 3)],
      title: Text('Sheet title'),
    );
    await _pumpSheet(
      tester,
      const InteractiveBottomSheet(
        options: InteractiveBottomSheetOptions(
          backgroundColor: Colors.yellow,
          initialSize: 0.5,
        ),
        draggableAreaOptions: area,
        footer: Text('Footer'),
        child: Text('Content'),
      ),
    );

    expect(tester.getSize(find.byType(SingleChildScrollView)).height, 100);
    expect(find.text('Sheet title'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Footer')).dy,
      greaterThan(tester.getTopLeft(find.text('Content')).dy),
    );
    final indicator = tester.widget<Container>(_indicator);
    expect(indicator.constraints!.maxWidth, 64);
    expect(indicator.constraints!.maxHeight, 8);
    expect(indicator.margin, area.indicatorPadding);
    final indicatorDecoration = indicator.decoration! as BoxDecoration;
    expect(indicatorDecoration.color, Colors.red);
    expect(
      indicatorDecoration.borderRadius,
      const BorderRadius.all(Radius.circular(4)),
    );

    final handle = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(SingleChildScrollView),
            matching: find.byType(Container),
          )
          .first,
    );
    final handleDecoration = handle.decoration! as BoxDecoration;
    expect(handleDecoration.color, Colors.blue);
    expect(
      handleDecoration.borderRadius,
      const BorderRadius.vertical(top: Radius.circular(24)),
    );
    expect(handleDecoration.boxShadow, area.shadows);
    final sheet = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(InteractiveBottomSheet),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final sheetDecoration = sheet.decoration as BoxDecoration;
    expect(sheetDecoration.color, Colors.yellow);
    expect(sheetDecoration.borderRadius, handleDecoration.borderRadius);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the taller default title area and footer-only content', (
    tester,
  ) async {
    await _pumpSheet(
      tester,
      const InteractiveBottomSheet(
        draggableAreaOptions: DraggableAreaOptions(
          title: Text('Title'),
        ),
        footer: Text('Footer without a child'),
      ),
    );

    expect(tester.getSize(find.byType(SingleChildScrollView)).height, 80);
    expect(tester.widget<Container>(_indicator).constraints!.maxWidth, 40);
    expect(find.text('Footer without a child'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('drags and snaps while respecting the fork minimum and maximum', (
    tester,
  ) async {
    await _pumpSheet(
      tester,
      const InteractiveBottomSheet(
        options: InteractiveBottomSheetOptions(
          minimumSize: 0.1,
          initialSize: 0.3,
          maxSize: 0.8,
          snapList: [0.6],
        ),
      ),
    );

    await _dragHandle(tester, 600);
    expect(_controller(tester).size, closeTo(0.1, 0.001));
    await _dragHandle(tester, -240);
    expect(_controller(tester).size, closeTo(0.6, 0.001));
    await _dragHandle(tester, -600);
    expect(_controller(tester).size, closeTo(0.8, 0.001));
    await _dragHandle(tester, 600);
    // Scaffold resets an expanded persistent sheet when its history is removed.
    expect(_controller(tester).size, closeTo(0.3, 0.001));
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports unsnapped dragging with expand enabled', (
    tester,
  ) async {
    await _pumpSheet(
      tester,
      const InteractiveBottomSheet(
        options: InteractiveBottomSheetOptions(expand: true, snap: false),
      ),
    );

    expect(tester.getSize(find.byType(DraggableScrollableSheet)).height, 600);
    await _dragHandle(tester, -120);
    expect(_controller(tester).size, closeTo(0.45, 0.001));
    expect(tester.takeException(), isNull);
  });

  testWidgets('scrolls content and footer independently of the drag handle', (
    tester,
  ) async {
    await _pumpSheet(
      tester,
      const InteractiveBottomSheet(
        options: InteractiveBottomSheetOptions(initialSize: 0.5),
        footer: Text('Footer'),
        child: SizedBox(height: 1000, child: Text('Long content')),
      ),
    );

    final handleTop = tester.getTopLeft(find.byType(IndicatorWidget));
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    expect(find.text('Footer').hitTestable(), findsOneWidget);
    expect(_controller(tester).size, 0.5);
    expect(tester.getTopLeft(find.byType(IndicatorWidget)), handleTop);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'allows taps and pans behind the sheet without leaking gestures',
    (
      tester,
    ) async {
      var taps = 0;
      var pans = 0;
      await _pumpSheet(
        tester,
        const InteractiveBottomSheet(child: SizedBox(height: 100)),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (_) => pans++,
          child: Stack(
            children: [
              Positioned(
                top: 24,
                left: 24,
                child: ElevatedButton(
                  onPressed: () => taps++,
                  child: const Text('Behind sheet'),
                ),
              ),
              Positioned(
                bottom: 24,
                left: 24,
                child: ElevatedButton(
                  onPressed: () => taps++,
                  child: const Text('Covered by sheet'),
                ),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Behind sheet'));
      expect(taps, 1);
      await tester.dragFrom(const Offset(400, 100), const Offset(100, 0));
      await tester.pumpAndSettle();
      expect(pans, greaterThan(0));
      final backgroundPans = pans;
      await _dragHandle(tester, -120);
      expect(pans, backgroundPans);
      expect(_controller(tester).size, closeTo(0.5, 0.001));
      await tester.tap(find.text('Behind sheet'));
      expect(taps, 2);
      await tester.tap(find.text('Covered by sheet'), warnIfMissed: false);
      expect(taps, 2);
      expect(tester.takeException(), isNull);
    },
  );
}

Future<void> _pumpSheet(
  WidgetTester tester,
  InteractiveBottomSheet sheet, {
  Widget? body,
}) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(
      bottomSheet: sheet,
      body: body,
    ),
  ),
);

Finder get _indicator => find.descendant(
  of: find.byType(IndicatorWidget),
  matching: find.byType(Container),
);

DraggableScrollableController _controller(WidgetTester tester) => tester
    .widget<DraggableScrollableSheet>(find.byType(DraggableScrollableSheet))
    .controller!;

Future<void> _dragHandle(WidgetTester tester, double distance) async {
  final gesture = await tester.startGesture(
    tester.getCenter(find.byType(IndicatorWidget)),
  );
  await gesture.moveBy(Offset(0, distance));
  // Release without fling velocity so the nearest snap point is deterministic.
  await tester.pump(const Duration(milliseconds: 500));
  await gesture.up();
  await tester.pumpAndSettle();
}
