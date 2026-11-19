import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/core/theme/app_colors.dart';
import 'package:sudoku/core/utils/duration_formatter.dart';
import 'package:sudoku/features/game/controller/game_controller.dart';

class GameHud extends ConsumerWidget {
  const GameHud({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      // Each slot scales its pill down instead of overflowing, so narrow
      // phones and large system font sizes both stay intact.
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: _LivesPill(
                remaining: gameState.livesLeft,
                colors: colors,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: _TimerPill(
                seconds: gameState.elapsedSeconds,
                colors: colors,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: _HintPill(
                hintsLeft: gameState.hintsLeft,
                colors: colors,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fixed-width regardless of difficulty, so the HUD can never overflow.
class _LivesPill extends StatelessWidget {
  final int remaining;
  final AppColorsExtension colors;

  const _LivesPill({required this.remaining, required this.colors});

  @override
  Widget build(BuildContext context) {
    final alive = remaining > 0;
    final color = alive ? colors.errorRed : colors.textDisabled;

    return Semantics(
      label: '$remaining lives left',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withValues(alpha: alive ? 0.75 : 0.3),
            width: 1.5,
          ),
          boxShadow: alive
              ? [
                  BoxShadow(
                    color: colors.errorRed.withValues(alpha: 0.18),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              alive ? Icons.favorite_rounded : Icons.heart_broken_rounded,
              color: color,
              size: 17,
            ),
            const SizedBox(width: 5),
            Text(
              '×$remaining',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerPill extends StatelessWidget {
  final int seconds;
  final AppColorsExtension colors;

  const _TimerPill({required this.seconds, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.primaryNeon.withValues(alpha: 0.75),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primaryNeon.withValues(alpha: 0.18),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            color: colors.primaryNeon.withValues(alpha: 0.8),
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            DurationFormatter.format(seconds),
            style: TextStyle(
              color: colors.primaryNeon,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HintPill extends StatelessWidget {
  final int hintsLeft;
  final AppColorsExtension colors;

  const _HintPill({required this.hintsLeft, required this.colors});

  @override
  Widget build(BuildContext context) {
    final hasHints = hintsLeft > 0;
    final color = hasHints ? colors.accentPurple : colors.textDisabled;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: hasHints ? 0.75 : 0.3),
          width: 1.5,
        ),
        boxShadow: hasHints
            ? [
                BoxShadow(
                  color: colors.accentPurple.withValues(alpha: 0.18),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lightbulb_rounded,
            color: color,
            size: 17,
          ),
          const SizedBox(width: 5),
          Text(
            '$hintsLeft',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
