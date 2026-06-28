import 'package:flutter/material.dart';
import 'package:rxget/rxget.dart';
import '../../../../core/const/constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../service/password_manager/domain/entities/vault_entry.dart';
import '../../controller/add_password/add_password_controller.dart';

class AddPasswordCategory extends StatelessWidget {
  const AddPasswordCategory({super.key});

  @override
  Widget build(BuildContext context) {
    Color getCategoryColor(VaultCategory cat) {
      switch (cat) {
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

    IconData getCategoryIcon(VaultCategory cat) {
      switch (cat) {
        case VaultCategory.social:
          return Icons.people_outline_rounded;
        case VaultCategory.email:
          return Icons.email_outlined;
        case VaultCategory.banking:
          return Icons.account_balance_outlined;
        case VaultCategory.shopping:
          return Icons.shopping_bag_outlined;
        case VaultCategory.work:
          return Icons.work_outline_rounded;
        case VaultCategory.other:
          return Icons.key_rounded;
      }
    }

    final controller = Get.find<AddPasswordController>();

    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: VaultCategory.values.map((VaultCategory cat) {
          final bool isSelected = controller.state.selectedCategory == cat;
          final Color color = getCategoryColor(cat);
          return GestureDetector(
            onTap: () {},
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? color.withAlpha(30) : cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? color : AppColors.textSecondary,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    getCategoryIcon(cat),
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat.label,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
