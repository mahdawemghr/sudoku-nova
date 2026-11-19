import 'package:flutter/material.dart';
import 'package:sudoku/core/theme/app_colors.dart';
import 'package:sudoku/data/models/difficulty.dart';

extension DifficultyStyle on Difficulty {
  Color color(AppColorsExtension colors) {
    switch (this) {
      case Difficulty.easy:
        return colors.secondaryNeon;
      case Difficulty.medium:
        return colors.primaryNeon;
      case Difficulty.hard:
        return colors.accentPurple;
      case Difficulty.impossible:
        return colors.errorRed;
    }
  }
}
