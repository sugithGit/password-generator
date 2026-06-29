import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_rxget/hooks_rxget.dart';
import 'package:rxget/rxget.dart';

import '../../../../core/routes/app_router.gr.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_button/app_button.dart';
import '../../../../core/widgets/squircle.dart';
import '../../../../service/password_manager/data/repositories/vault_repo_impl.dart';
import '../../controller/gateway/gateway_controller.dart';

@RoutePage()
class BiometricGatePage extends HookWidget {
  const BiometricGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    useGetIn<GatewayController>(GetIn(GatewayController.new));
    final GatewayController controller = Get.find<GatewayController>();

    final AnimationController pulseController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
    );

    final Animation<double> pulseAnimation = useMemoized(
      () => Tween<double>(begin: 0.95, end: 1.05).animate(
        CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
      ),
      <Object?>[pulseController],
    );

    final VoidCallback navigateToMasterKey = useCallback(() {
      if (!context.mounted) {
        return;
      }
      context.router.replace(const MasterKeyRoute());
    }, <Object?>[context, controller]);

    final VoidCallback authenticate = useCallback(() {
      controller.authenticate(
        onBiometricsUnsupported: navigateToMasterKey,
        onBiometricsSuccessWithKey: (String masterKey) {
          controller.onMasterKeyValidated(
            masterKey,
            onReady: (VaultRepoImpl repository) {
              if (!context.mounted) {
                return;
              }
              context.router.replace(VaultRoute(repository: repository));
            },
            onError: (String error) {
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error)));
              }
            },
          );
        },
        onRequiresMasterKeyCreation: navigateToMasterKey,
        onRequiresMasterKeyInput: navigateToMasterKey,
        onAuthError: (String error) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error)));
            context.router.replace(const LoginRoute());
          }
        },
      );
    }, <Object?>[controller, navigateToMasterKey, context]);

    useEffect(() {
      pulseController.repeat(reverse: true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        authenticate();
      });
      return null;
    }, const <Object?>[]);

    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Animated lock icon
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: AnimatedBuilder(
                        animation: pulseAnimation,
                        builder: (BuildContext context, Widget? child) {
                          return Transform.scale(
                            scale: pulseAnimation.value,
                            child: child,
                          );
                        },
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Icon(
                            controller.state.authFailed
                                ? Icons.lock_outline_rounded
                                : Icons.fingerprint_rounded,
                            size: 52,
                            color: controller.state.authFailed
                                ? theme.colorScheme.error
                                : const Color(0xFF3ECF8E),
                          ),
                        ),
                      ),
                    ),
                    // Title
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 100),
                      child: Text(
                        controller.state.authFailed
                            ? 'Auth Failed'
                            : 'Identity',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          letterSpacing: -1,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Subtitle
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        controller.state.authFailed
                            ? 'Please try again to access your vault'
                            : 'Use biometrics or device PIN to\naccess your secure vault.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary.withAlpha(200),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Loading or retry
                    if (controller.state.isAuthenticating)
                      const FadeIn(
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            color: Color(0xFF3ECF8E),
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    else if (controller.state.authFailed)
                      FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        child: Column(
                          children: <Widget>[
                            AppButton(
                              onPressed: authenticate,
                              title: 'TRY AGAIN',
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => context.router.maybePop(),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.textPrimary
                                    .withAlpha(200),
                              ),
                              child: const Text('Go Back'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
