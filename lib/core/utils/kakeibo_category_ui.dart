import 'package:flutter/material.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/constants/app_strings.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';

/// Mapea [KakeiboCategory] a propiedades visuales para la UI.
class KakeiboCategoryUi {
  KakeiboCategoryUi._();

  static Color color(KakeiboCategory category) {
    return switch (category) {
      KakeiboCategory.survival => AppColors.blue,
      KakeiboCategory.culture => AppColors.green,
      KakeiboCategory.leisure => AppColors.gold,
      KakeiboCategory.extras => AppColors.error,
      KakeiboCategory.allowance => const Color(0xFFB57BFF),
      KakeiboCategory.investment => const Color(0xFF4DD0E1),
    };
  }

  static String label(KakeiboCategory category) {
    return switch (category) {
      KakeiboCategory.survival => AppStrings.kakeiboCategorySupervivencia,
      KakeiboCategory.culture => AppStrings.kakeiboCategorycultura,
      KakeiboCategory.leisure => AppStrings.kakeiboCategoryOcio,
      KakeiboCategory.extras => AppStrings.kakeiboCategoryExtras,
      KakeiboCategory.allowance => AppStrings.kakeiboCategoryMesada,
      KakeiboCategory.investment => AppStrings.kakeiboCategoryInversion,
    };
  }

  static String emoji(KakeiboCategory category) {
    return switch (category) {
      KakeiboCategory.survival => '🏠',
      KakeiboCategory.culture => '📚',
      KakeiboCategory.leisure => '🎭',
      KakeiboCategory.extras => '⭐',
      KakeiboCategory.allowance => '👧',
      KakeiboCategory.investment => '📈',
    };
  }
}
