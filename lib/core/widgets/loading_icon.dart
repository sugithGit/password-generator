import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../theme/app_colors.dart';

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({
    this.colors,
    super.key,
  });

  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    final colors = this.colors ?? [AppColors.textPrimary];
    return Center(
      child: SizedBox(
        width: 58,
        height: 14,
        child: LoadingIndicator(
          indicatorType: Indicator.ballBeat,

          /// Required, The loading type of the widget
          colors: colors,

          /// Optional, The color collections
          strokeWidth: 1,

          /// Optional, The stroke of the line, only applicable to widget which contains line

          /// Optional, the stroke backgroundColor
        ),
      ),
    );
  }
}
