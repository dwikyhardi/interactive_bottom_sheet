import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_bottom_sheet/interactive_bottom_sheet.dart';
import 'package:interactive_bottom_sheet_example/main.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('example lays out its long content inside the fork sheet', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(InteractiveBottomSheet), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(InteractiveBottomSheet)))
          .useMaterial3,
      isTrue,
    );
    expect(find.text('Interactive Bottom Sheet Example'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
