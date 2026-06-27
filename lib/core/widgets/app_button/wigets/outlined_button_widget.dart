part of '../app_button.dart';

class _OutlinedButton extends StatelessWidget {
  const _OutlinedButton({
    required this.onPressed,
    required this.title,
    required this.isBtnDisabled,
    required this.roundBtn,
    required this.bgColor,
    this.isLoading = false,
    this.largeButton = false,
    this.textColor,
    this.padding,
  });

  final bool isLoading;
  final VoidCallback? onPressed;
  final String title;
  final bool largeButton;
  final Color? textColor;
  final bool isBtnDisabled;
  final bool roundBtn;
  final EdgeInsetsGeometry? padding;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    const disabledColor = AppColors.mutedForeground;
    final buttonBorderColor = isBtnDisabled
        ? disabledColor
        : bgColor ?? AppColors.deepTeal;
    final buttonTextColor = isBtnDisabled
        ? disabledColor
        : textColor ?? AppColors.deepTeal;

    return OutlinedButton(
      onPressed: isBtnDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        textStyle: context.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        shape: roundBtn
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
            : const Squircle().outlinedShape(),
        side: BorderSide(
          color: buttonBorderColor,
          // width: 1,
        ),
        foregroundColor: buttonTextColor,
        backgroundColor: Colors.transparent,
        padding: padding,
        elevation: 0,
      ),
      child: isLoading
          ? const LoadingIcon(colors: [Colors.white])
          : Text(
              title,
              style: context.titleMedium?.copyWith(
                color: buttonTextColor,
                fontWeight: FontWeight.w600,
                fontSize: largeButton ? 18 : null,
              ),
            ),
    );
  }
}
