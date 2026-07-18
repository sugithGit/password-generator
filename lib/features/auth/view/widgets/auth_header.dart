import 'package:flutter/material.dart';

import '../../../../core/extension/color_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../vault/view/widgets/emoji_pill.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({required this.isSignUp, super.key});

  final bool isSignUp;

  @override
  Widget build(BuildContext context) {
    final String row1Text = isSignUp ? 'Create' : 'Welcome';
    final String row1Emoji = isSignUp ? '✨' : '👋';
    final String row2Text = isSignUp ? 'New' : 'Back';
    final String row3Text = isSignUp ? 'Account' : 'To Vault';
    const String row3Emoji = '🔒';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              row1Text,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                letterSpacing: -1,
                height: 1.1,
              ),
            ),
            const SizedBox(width: 12),
            EmojiPill(emoji: row1Emoji, bgColor: Colors.black.op(0.3)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Text(
              row2Text,
              style: const TextStyle(
                fontSize: 42,
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
            Text(
              row3Text,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                letterSpacing: -1,
                height: 1.1,
              ),
            ),
            const SizedBox(width: 12),
            EmojiPill(emoji: row3Emoji, bgColor: Colors.white.op(0.04)),
          ],
        ),
      ],
    );
  }
}
