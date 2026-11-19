import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku/core/services/sound_service.dart';
import 'package:sudoku/core/theme/app_colors.dart';
import 'package:sudoku/data/models/difficulty.dart';
import 'package:sudoku/data/models/saved_game.dart';
import 'package:sudoku/data/repositories/game_repository.dart';
import 'package:sudoku/data/repositories/stats_repository.dart';
import 'package:sudoku/features/menu/widgets/best_scores_panel.dart';
import 'package:sudoku/features/menu/widgets/hero_card.dart';
import 'package:sudoku/features/menu/widgets/menu_nav_tile.dart';

final bestTimesProvider = FutureProvider.autoDispose<Map<Difficulty, int?>>((
  ref,
) async {
  return StatsRepository().getAllBestTimes();
});

final savedGameProvider = FutureProvider.autoDispose<SavedGame?>((ref) async {
  return GameRepository().loadCurrentGame();
});

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestTimesAsync = ref.watch(bestTimesProvider);
    final saved = ref.watch(savedGameProvider).valueOrNull;
    final colors = context.appColors;
    final animate = !MediaQuery.disableAnimationsOf(context);

    // Entrance: ease-out fade + short slide, staggered 50 ms, first build only.
    Widget enter(Widget child, int step) {
      if (!animate) return child;
      return child
          .animate(delay: (step * 50).ms)
          .fadeIn(duration: 260.ms, curve: Curves.easeOut)
          .slideY(begin: 0.06, end: 0, duration: 260.ms, curve: Curves.easeOut);
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    enter(const _Header(), 0),
                    const SizedBox(height: 32),
                    enter(
                      HeroCard(
                        resumeDifficulty: saved?.difficulty,
                        onTap: () => saved == null
                            ? context.push('/difficulty')
                            : context.go('/game?resume=true'),
                      ),
                      1,
                    ),
                    if (saved != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            SoundService().playTap();
                            context.push('/difficulty');
                          },
                          child: Text(
                            'Start a new game',
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 8),
                    const SizedBox(height: 20),
                    enter(const _SectionLabel('BEST TIMES'), 2),
                    const SizedBox(height: 12),
                    enter(
                      bestTimesAsync.when(
                        loading: () => const SizedBox(height: 4 * 46),
                        error: (e, s) => Text(
                          'Could not load best times',
                          style: TextStyle(color: colors.textSecondary),
                        ),
                        data: (times) => BestScoresPanel(bestTimes: times),
                      ),
                      3,
                    ),
                    const Spacer(),
                    const SizedBox(height: 24),
                    enter(
                      Row(
                        children: [
                          Expanded(
                            child: MenuNavTile(
                              icon: Icons.history_rounded,
                              label: 'History',
                              onTap: () => context.push('/history'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MenuNavTile(
                              icon: Icons.settings_rounded,
                              label: 'Settings',
                              onTap: () => context.push('/settings'),
                            ),
                          ),
                        ],
                      ),
                      4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SUDOKU',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 44,
            height: 1,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        Text(
          'NOVA',
          style: TextStyle(
            color: colors.primaryNeon,
            fontSize: 44,
            height: 1.05,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Four difficulties. Plays offline.',
          style: TextStyle(color: colors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: context.appColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.2,
      ),
    );
  }
}
