import '../../../../core/extension/color_ext.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'emoji_pill.dart';

class HeroText extends StatelessWidget {
  const HeroText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Text(
              'Keep',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                letterSpacing: -1,
                height: 1.1,
              ),
            ),
            const SizedBox(width: 12),
            EmojiPill(emoji: '🔒', bgColor: Colors.black.op(0.2)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            EmojiPill(emoji: '🗄️', bgColor: Colors.black.op(0.2)),
            const SizedBox(width: 12),
            const Text(
              'Your Life',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                letterSpacing: -1,
                height: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            const Text(
              'Safe',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                letterSpacing: -1,
                height: 1.1,
              ),
            ),
            const SizedBox(width: 12),
            EmojiPill(emoji: '🌍', bgColor: Colors.black.op(0.2)),
          ],
        ),
      ],
    );
  }
}
