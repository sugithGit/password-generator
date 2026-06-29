import 'package:flutter/material.dart';

import '../../../../core/extension/color_ext.dart';

class NavIcon extends StatelessWidget {
  const NavIcon({
    required this.icon,
    required this.color,
    required this.isSelected,
    super.key,
  });

  final IconData icon;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      margin: const EdgeInsets.only(right: 8),
      decoration: ShapeDecoration(
        color: isSelected ? Colors.white.op(0.2) : Colors.transparent,
        shape: const CircleBorder(),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
