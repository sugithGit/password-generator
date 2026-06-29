import 'package:flutter/material.dart';

import '../../../../core/extension/color_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../vault/view/widgets/emoji_pill.dart';

class MasterKeyHeader extends StatelessWidget {
  const MasterKeyHeader({required this.isNewUser, super.key});

  final bool isNewUser;

  @override
  Widget build(BuildContext context) {
    final String row1Text = isNewUser ? 'Create' : 'Unlock';
    final String row1Emoji = isNewUser ? '🔑' : '🔓';
    final String row2Text = isNewUser ? 'Master Key' : 'Your';
    final String row3Text = isNewUser ? 'Crucial' : 'Vault';
    final String row3Emoji = isNewUser ? '⚠️' : '🛡️';

    final String subtitleText = isNewUser
        ? 'This key encrypts your vault.\nIf lost, your data cannot be recovered.\nKeep it safe!'
        : 'Enter your master key to decrypt and access your secure vault.';

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
        const SizedBox(height: 24),
        Text(
          subtitleText,
          style: TextStyle(
            color: AppColors.textPrimary.op(0.8),
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
