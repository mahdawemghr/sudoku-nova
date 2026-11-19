import 'package:flutter/material.dart';
import 'package:sudoku/core/services/sound_service.dart';
import 'package:sudoku/core/theme/app_colors.dart';

/// Icon + label tile for the menu's bottom row (History, Settings).
class MenuNavTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MenuNavTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<MenuNavTile> createState() => _MenuNavTileState();
}

class _MenuNavTileState extends State<MenuNavTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Semantics(
      button: true,
      label: widget.label,
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
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            decoration: BoxDecoration(
              color: _pressed ? colors.surfaceVariant : colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 20, color: colors.textSecondary),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
