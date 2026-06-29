import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF3ECF8E), // Vibrant Supabase Green at the top
            Color(0xFF1B6A42), // Transition to dark green
            AppColors.background, // Fades perfectly into black
          ],
          stops: <double>[0, 0.14, 0.28],
        ),
      ),
      child: child,
    );
  }
}
