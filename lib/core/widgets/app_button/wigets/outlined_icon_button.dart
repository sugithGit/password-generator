import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../theme/app_colors.dart';
import '../../squircle.dart';

class OutlinedIconButton extends StatelessWidget {
  const OutlinedIconButton({
    required this.title,
    required this.leading,
    required this.onPressed,
    this.selected = false,
    super.key,
  });

  final String title;
  final Widget leading;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        Feedback.forTap(context);
        HapticFeedback.lightImpact();
        onPressed();
      },
      label: Row(
        children: [
          leading,
          const Gap(12),
          Text(
            title,
            style: TextStyle(
              color: selected ? AppColors.background : AppColors.textPrimary,
            ),
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: selected ? AppColors.deepTeal : null,
        minimumSize: const Size.fromHeight(48),
        side: BorderSide(
          color: selected ? AppColors.deepTeal : Colors.grey,
        ),
        shape: const Squircle().outlinedShape(),
        padding: const EdgeInsets.only(left: 16),
      ),
    );
  }
}
