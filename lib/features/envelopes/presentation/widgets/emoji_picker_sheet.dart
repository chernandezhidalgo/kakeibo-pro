import 'package:flutter/material.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';

/// Bottom sheet con una grilla de emojis frecuentes para sobres.
class EmojiPickerSheet extends StatelessWidget {
  final String selectedEmoji;
  final ValueChanged<String> onSelected;

  const EmojiPickerSheet({
    super.key,
    required this.selectedEmoji,
    required this.onSelected,
  });

  static const _emojis = [
    '💰', '🛒', '⛽', '💡', '🏠', '🏥', '💊', '💳',
    '📚', '🎓', '🎬', '🎭', '🍽️', '☕', '🎮', '✈️',
    '👕', '👟', '💄', '🐾', '🎁', '⭐', '🔧', '🚗',
    '🌿', '🏋️', '💎', '📱', '🎵', '🍕', '🏖️', '📈',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle visual
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Elige un emoji',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _emojis.length,
            itemBuilder: (context, index) {
              final emoji = _emojis[index];
              final isSelected = emoji == selectedEmoji;
              return GestureDetector(
                onTap: () {
                  onSelected(emoji);
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.green.withValues(alpha: 0.2)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? Border.all(color: AppColors.green, width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
