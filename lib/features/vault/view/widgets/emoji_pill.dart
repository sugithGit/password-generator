import 'package:flutter/material.dart';
import '../../../../core/widgets/squircle.dart';

class EmojiPill extends StatelessWidget {
  const EmojiPill({
    required this.emoji,
    required this.bgColor,
    super.key,
  });

  final String emoji;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: const Squircle(radius: 100).shape(),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 26)),
    );
  }
}
