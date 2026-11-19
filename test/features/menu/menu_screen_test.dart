import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/core/theme/app_theme.dart';
import 'package:sudoku/data/models/difficulty.dart';
import 'package:sudoku/features/menu/menu_screen.dart';

Widget _buildMenu() {
  return ProviderScope(
    overrides: [
      bestTimesProvider.overrideWith(
        (ref) async => {
          Difficulty.easy: 125,
          Difficulty.medium: null,
          Difficulty.hard: null,
          Difficulty.impossible: null,
        },
      ),
      savedGameProvider.overrideWith((ref) async => null),
    ],
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: const MenuScreen(),
    ),
  );
}

void main() {
  for (final size in const [Size(320, 568), Size(411, 891)]) {
    testWidgets('menu renders without overflow at ${size.width.toInt()}px',
        (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildMenu());
      // The hero card's glow loops forever, so pumpAndSettle would never return.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull);
      expect(find.text('Play'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('02:05'), findsOneWidget);
    });
  }
}
