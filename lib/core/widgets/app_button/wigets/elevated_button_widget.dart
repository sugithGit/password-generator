part of '../app_button.dart';

class _ElevatedButton extends StatelessWidget {
  const _ElevatedButton({
    required this.isBtnDisabled,
    required this.onPressed,
    required this.disabledBg,
    required this.bgColor,
    required this.elevation,
    required this.isLoading,
    required this.title,
    required this.textColor,
    required this.largeButton,
    required this.icon,
    required this.roundBtn,
  });

  final bool isBtnDisabled;
  final VoidCallback? onPressed;
  final Color disabledBg;
  final Color? bgColor;
  final double elevation;
  final bool isLoading;
  final String title;
  final Color textColor;
  final bool largeButton;
  final Widget? icon;
  final bool roundBtn;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isBtnDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        textStyle: context.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        shape: Squircle(radius: roundBtn ? 100 : bR).outlinedShape(),
        backgroundColor: isBtnDisabled
            ? disabledBg
            : bgColor ?? AppColors.deepTeal,
        foregroundColor: isBtnDisabled
            ? AppColors.textDisabled
            : AppColors.background,
        disabledBackgroundColor: disabledBg,
        disabledForegroundColor: AppColors.textDisabled,
        elevation: isBtnDisabled ? 0 : elevation,
      ),
      child: isLoading
          ? LoadingIcon(colors: [textColor])
          : Row(
              mainAxisAlignment: .center,
              children: [
                ?icon?.paddingOnly(right: 12),
                Text(
                  title,
                  style: context.titleMedium?.copyWith(
                    color: isBtnDisabled ? AppColors.textDisabled : textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: largeButton ? 18 : null,
                  ),
                ),
              ],
            ),
    );
  }
}
