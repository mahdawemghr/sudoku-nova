import 'package:flutter/material.dart';
import 'package:sudoku/core/services/sound_service.dart';
import 'package:sudoku/core/theme/app_colors.dart';
import 'package:sudoku/data/models/difficulty.dart';
import 'package:sudoku/shared/difficulty_style.dart';

/// The menu's single focal point: continue a saved game, or start a new one.
/// Its border glow breathes slowly (the screen's one signature moment) and
/// stays still when the system asks for reduced motion.
class HeroCard extends StatefulWidget {
  final Difficulty? resumeDifficulty;
  final VoidCallback onTap;

  const HeroCard({super.key, required this.onTap, this.resumeDifficulty});

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glow = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  bool _pressed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _glow.stop();
      _glow.value = 0.5;
    } else if (!_glow.isAnimating) {
      _glow.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final resume = widget.resumeDifficulty;
    final accent = resume?.color(colors) ?? colors.primaryNeon;
    final eyebrow = resume == null ? 'NEW GAME' : 'CONTINUE';
    final title = resume == null ? 'Play' : resume.displayName;
    final hint =
        resume == null ? 'Pick a difficulty and go' : 'Pick up where you left off';

    return Semantics(
      button: true,
      label: resume == null ? 'Play' : 'Continue ${resume.displayName} game',
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          SoundService().playTap();
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _glow,
              builder: (context, child) => Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.55 + 0.35 * _glow.value),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.10 + 0.14 * _glow.value),
                      blurRadius: 18 + 12 * _glow.value,
                    ),
                  ],
                ),
                child: child,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 20, 22),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eyebrow,
                            style: TextStyle(
                              color: accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            title,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 38,
                              height: 1.05,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            hint,
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 36,
                        color: colors.background,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
