import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';

import '../../const/ui/ds_const.dart';
import '../../theme/app_colors.dart';
import '../loading_icon.dart';
import '../squircle.dart';

part 'wigets/elevated_button_widget.dart';
part 'wigets/outlined_button_widget.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.title,
    super.key,
    this.isLoading = false,
    this.largeButton = false,
    this.disabled = false,
    this.bgColor,
    this.elevation = 2,
    this.textColor,
    this.isOutlined = false,
    this.expand = true,
    this.icon,
    this.disabledBg,
    this.roundBtn = false,
    this.childPadding,
  });

  final bool isLoading;
  final VoidCallback? onPressed;
  final String title;
  final bool largeButton;
  final bool disabled;
  final Color? bgColor;
  final double elevation;
  final Color? textColor;
  final bool isOutlined;
  final bool expand;
  final Widget? icon;
  final Color? disabledBg;
  final bool roundBtn;
  final EdgeInsetsGeometry? childPadding;

  @override
  Widget build(BuildContext context) {
    final textColor = this.textColor ?? Colors.black;
    final isBtnDisabled = disabled || onPressed == null;
    final disabledBg =
        this.disabledBg ?? AppColors.muted; // Soft neutral gray for disabled

    return SizedBox(
      width: expand ? double.infinity : null,
      height: largeButton ? 54 : 52,
      child: isOutlined
          ? _OutlinedButton(
              onPressed: onPressed,
              isLoading: isLoading,
              title: title,
              textColor: textColor,
              largeButton: largeButton,
              isBtnDisabled: isBtnDisabled,
              roundBtn: roundBtn,
              padding: childPadding,
              bgColor: bgColor,
            )
          : _ElevatedButton(
              isBtnDisabled: isBtnDisabled,
              onPressed: onPressed,
              disabledBg: disabledBg,
              bgColor: bgColor,
              elevation: elevation,
              isLoading: isLoading,
              title: title,
              textColor: textColor,
              largeButton: largeButton,
              icon: icon,
              roundBtn: roundBtn,
            ),
    );
  }
}
