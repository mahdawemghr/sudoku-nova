import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku/core/services/sound_service.dart';
import 'package:sudoku/core/theme/app_colors.dart';
import 'package:sudoku/data/models/difficulty.dart';
import 'package:sudoku/shared/difficulty_style.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  static const _subtitles = {
    Difficulty.easy: 'Great for beginners',
    Difficulty.medium: 'A balanced challenge',
    Difficulty.hard: 'Test your skills',
    Difficulty.impossible: 'Only for masters',
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final animate = !MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.textSecondary,
          ),
          onPressed: () {
            SoundService().playTap();
            context.go('/');
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          children: [
            Text(
              'Choose your\nchallenge',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 34,
                height: 1.1,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 28),
            for (final (i, d) in Difficulty.values.indexed) ...[
              if (i > 0) const SizedBox(height: 12),
              _entrance(
                _DifficultyCard(difficulty: d, subtitle: _subtitles[d]!),
                i,
                animate,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _entrance(Widget child, int index, bool animate) {
    if (!animate) return child;
    return child
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: 260.ms, curve: Curves.easeOut)
        .slideY(begin: 0.06, end: 0, duration: 260.ms, curve: Curves.easeOut);
  }
}

class _DifficultyCard extends StatefulWidget {
  final Difficulty difficulty;
  final String subtitle;

  const _DifficultyCard({required this.difficulty, required this.subtitle});

  @override
  State<_DifficultyCard> createState() => _DifficultyCardState();
}

class _DifficultyCardState extends State<_DifficultyCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final d = widget.difficulty;
    final color = d.color(colors);

    return Semantics(
      button: true,
      label:
          '${d.displayName}. ${widget.subtitle}. ${d.maxLives} lives, ${d.maxHints} hints.',
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          SoundService().playTap();
          context.go('/game?difficulty=${d.label}');
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
            decoration: BoxDecoration(
              color: _pressed ? colors.surfaceVariant : colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: _pressed ? 0.9 : 0.45),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.displayName,
                        style: TextStyle(
                          color: color,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _Stat(
                            icon: Icons.favorite_rounded,
                            value: '${d.maxLives}',
                            color: colors.textSecondary,
                          ),
                          const SizedBox(width: 16),
                          _Stat(
                            icon: Icons.lightbulb_rounded,
                            value: '${d.maxHints}',
                            color: colors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: color,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _Stat({required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 5),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
