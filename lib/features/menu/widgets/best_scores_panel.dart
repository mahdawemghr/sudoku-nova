import 'package:flutter/material.dart';
import 'package:sudoku/core/theme/app_colors.dart';
import 'package:sudoku/core/utils/duration_formatter.dart';
import 'package:sudoku/data/models/difficulty.dart';
import 'package:sudoku/shared/difficulty_style.dart';

/// Four compact rows, one per difficulty: a quiet reference, not a competitor
/// to the hero card.
class BestScoresPanel extends StatelessWidget {
  final Map<Difficulty, int?> bestTimes;

  const BestScoresPanel({super.key, required this.bestTimes});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    const difficulties = Difficulty.values;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < difficulties.length; i++) ...[
            if (i > 0) Divider(height: 1, thickness: 1, color: colors.divider),
            _ScoreRow(difficulty: difficulties[i], time: bestTimes[difficulties[i]]),
          ],
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final Difficulty difficulty;
  final int? time;

  const _ScoreRow({required this.difficulty, required this.time});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = difficulty.color(colors);
    final hasTime = time != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              difficulty.displayName,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            hasTime ? DurationFormatter.format(time!) : '--:--',
            style: TextStyle(
              color: hasTime ? colors.textPrimary : colors.textDisabled,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
