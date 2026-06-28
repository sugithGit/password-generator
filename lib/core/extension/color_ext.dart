import 'package:flutter/material.dart';

extension ColorX on Color {
  /// Opacity
  Color op(double v) => withValues(alpha: v);

  ColorFilter get colorFilter => ColorFilter.mode(this, BlendMode.srcIn);
}
