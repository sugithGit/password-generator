import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../const/ui/ds_const.dart';
import '../theme/app_colors.dart';
import 'squircle.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => context.router.maybePop(),

        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: AppColors.cardVariant,
            shape: const Squircle(radius: bR).shape(),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
      ),
    );
  }
}
