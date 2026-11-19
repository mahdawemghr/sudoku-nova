import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sudoku/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SudokuNovaApp()),
    );
    // The menu's hero glow loops forever, so pumpAndSettle would never return.
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });
}
