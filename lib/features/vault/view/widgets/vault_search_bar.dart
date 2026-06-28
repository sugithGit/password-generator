import 'package:flutter/material.dart';

import '../../../../core/extension/color_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/squircle.dart';

class VaultSearchBar extends StatelessWidget {
  const VaultSearchBar({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Colors.white.op(0.1),
          shape: const Squircle(
            radius: 100,
          ).shape(side: BorderSide(color: Colors.white.op(0.05))),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(
              color: AppColors.textSecondary.op(0.6),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 22,
              color: AppColors.textSecondary.op(0.8),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: AppColors.textSecondary,
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: AppColors.textSecondary.op(0.8),
                  ),
                ),
              ],
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
      ),
    );
  }
}
