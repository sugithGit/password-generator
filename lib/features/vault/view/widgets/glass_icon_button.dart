import 'package:flutter/material.dart';

import '../../../../core/extension/color_ext.dart';
import '../../../../core/theme/app_colors.dart';

class GlassIconButton extends StatelessWidget {
  const GlassIconButton({required this.icon, required this.onTap, super.key});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: ShapeDecoration(
          color: Colors.white.op(0.15),
          shape: const CircleBorder(),
          shadows: <BoxShadow>[
            BoxShadow(
              color: Colors.black.op(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}
