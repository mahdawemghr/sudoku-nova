import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/core/theme/app_theme.dart';
import 'package:sudoku/data/models/difficulty.dart';
import 'package:sudoku/data/repositories/game_repository.dart';
import 'package:sudoku/data/repositories/stats_repository.dart';
import 'package:sudoku/features/game/controller/game_controller.dart';
import 'package:sudoku/features/game/state/game_state.dart';
import 'package:sudoku/features/game/widgets/game_hud.dart';

class _FakeController extends GameController {
  _FakeController(GameState initial)
      : super(
          gameRepository: GameRepository(),
          statsRepository: StatsRepository(),
        ) {
    state = initial;
  }
}

Widget _buildHud({required double width, double textScale = 1.0}) {
  final initial = GameState.initial().copyWith(
    phase: GamePhase.playing,
    difficulty: Difficulty.easy,
    livesLeft: Difficulty.easy.maxLives,
    hintsLeft: Difficulty.easy.maxHints,
    elapsedSeconds: 3599,
  );
  return ProviderScope(
    overrides: [
      gameControllerProvider.overrideWith((ref) => _FakeController(initial)),
    ],
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: MediaQuery(
        data: MediaQueryData(
          size: Size(width, 700),
          textScaler: TextScaler.linear(textScale),
        ),
        child: const Scaffold(body: GameHud()),
      ),
    ),
  );
}

void main() {
  testWidgets('easy mode HUD does not overflow on a 320px-wide screen',
      (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_buildHud(width: 320));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('×5'), findsOneWidget);
  });

  testWidgets('HUD survives a large system font scale', (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_buildHud(width: 320, textScale: 1.3));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
