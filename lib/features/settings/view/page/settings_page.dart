import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rxget/rxget.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/extension/color_ext.dart';
import '../../../../core/routes/app_router.gr.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_bar/page_app_bar.dart';
import '../../../../core/widgets/squircle.dart';
import '../../../auth/controller/auth_controller.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final String email = controller.state.user?.email ?? 'No email associated';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PageAppBar(title: 'Settings'),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FadeInDown(
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      color: AppColors.card,
                      shape: const Squircle().shape(
                        side: const BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const ShapeDecoration(
                            color: AppColors.glowGreen,
                            shape: CircleBorder(),
                          ),
                          child: const Icon(
                            CupertinoIcons.person_crop_circle_fill,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Logged in as',
                                style: context.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                email,
                                style: context.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(32),
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    'ACCOUNT ACTIONS',
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const Gap(12),
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 200),
                  child: _SettingsTile(
                    title: 'Reset Account Password',
                    subtitle: 'Send a reset email to your address',
                    icon: Icons.lock_reset_rounded,
                    onTap: () =>
                        _showResetPasswordDialog(context, controller, email),
                  ),
                ),
                const Gap(12),
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 300),
                  child: _SettingsTile(
                    title: 'Sign Out',
                    subtitle: 'Logout from your session',
                    icon: Icons.logout_rounded,
                    onTap: () => _showSignOutDialog(context, controller),
                  ),
                ),
                const Gap(12),
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 400),
                  child: _SettingsTile(
                    title: 'Delete Account',
                    subtitle: 'Permanently remove your account & data',
                    icon: Icons.delete_forever_rounded,
                    iconColor: AppColors.error,
                    titleColor: AppColors.error,
                    onTap: () => _showDeleteAccountDialog(context, controller),
                  ),
                ),
                const Spacer(),
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 500),
                  child: Center(
                    child: Text(
                      'v1.9.0 (10)',
                      style: context.bodySmall?.copyWith(
                        color: AppColors.textSecondary.op(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.titleColor,
    this.iconColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: ShapeDecoration(
          color: AppColors.card,
          shape: const Squircle(
            radius: 16,
          ).shape(side: const BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: iconColor ?? AppColors.primary, size: 24),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    subtitle,
                    style: context.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_forward,
              color: AppColors.textSecondary.op(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

void _showResetPasswordDialog(
  BuildContext context,
  AuthController controller,
  String email,
) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        backgroundColor: AppColors.background,
        shape: const Squircle().shape(
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text('Reset Password', style: context.titleLarge),
        content: Text(
          'We will send a password reset email to $email. Do you wish to proceed?',
          style: context.bodyMedium,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await controller.sendPasswordResetEmail(email);
                if (context.mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    style: ToastificationStyle.flatColored,
                    title: const Text('Reset email sent successfully'),
                    autoCloseDuration: const Duration(seconds: 4),
                  );
                }
              } on Exception catch (e) {
                if (context.mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.error,
                    style: ToastificationStyle.flatColored,
                    title: Text(
                      'Failed: ${e.toString().replaceAll('Exception: ', '')}',
                    ),
                    autoCloseDuration: const Duration(seconds: 4),
                  );
                }
              }
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      );
    },
  );
}

void _showDeleteAccountDialog(BuildContext context, AuthController controller) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        backgroundColor: AppColors.background,
        shape: const Squircle().shape(
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Delete Account',
          style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you absolutely sure you want to delete your account? This action is permanent and all your saved vault entries will be lost.',
          style: context.bodyMedium,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await controller.deleteAccount();
                if (context.mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    style: ToastificationStyle.flatColored,
                    title: const Text('Account deleted successfully'),
                    autoCloseDuration: const Duration(seconds: 4),
                  );
                  await context.router.replaceAll(<PageRouteInfo>[
                    const LoginRoute(),
                  ]);
                }
              } on Exception catch (e) {
                if (context.mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.error,
                    style: ToastificationStyle.flatColored,
                    title: Text(
                      'Failed: ${e.toString().replaceAll('Exception: ', '')}',
                    ),
                    autoCloseDuration: const Duration(seconds: 4),
                  );
                }
              }
            },
            child: const Text(
              'Delete Permanently',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      );
    },
  );
}

void _showSignOutDialog(BuildContext context, AuthController controller) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        backgroundColor: AppColors.background,
        shape: const Squircle().shape(
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text('Sign Out', style: context.titleLarge),
        content: Text(
          'Are you sure you want to sign out?',
          style: context.bodyMedium,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await controller.signOut();
              if (context.mounted) {
                await context.router.replaceAll(<PageRouteInfo>[
                  const LoginRoute(),
                ]);
              }
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      );
    },
  );
}
