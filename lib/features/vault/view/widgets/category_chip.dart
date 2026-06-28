import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../core/const/constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/squircle.dart';
import '../../../../service/password_manager/domain/entities/vault_category.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final VaultCategory? category;
  final bool isSelected;
  final VoidCallback onTap;

  Color _getColor(BuildContext context) {
    if (category == null) {
      return Theme.of(context).colorScheme.primary;
    }
    switch (category!) {
      case VaultCategory.social:
        return categorySocial;
      case VaultCategory.email:
        return categoryEmail;
      case VaultCategory.banking:
        return categoryBanking;
      case VaultCategory.shopping:
        return categoryShopping;
      case VaultCategory.work:
        return categoryWork;
      case VaultCategory.other:
        return categoryOther;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = _getColor(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected ? color.withAlpha(40) : Colors.transparent,
          shape: const Squircle().shape(
            side: BorderSide(
              color: isSelected ? color : theme.dividerColor.withAlpha(80),
              width: isSelected ? 1.5 : 1,
            ),
          ),
        ),
        child: Text(
          category?.label ?? 'All',
          style: context.titleLarge?.copyWith(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
