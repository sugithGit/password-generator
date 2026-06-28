import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rxget/rxget.dart';

import '../../../../core/routes/app_router.gr.dart';
import '../../../../service/password_manager/data/repositories/vault_repo_impl.dart';
import '../../controller/gateway/gateway_controller.dart';

@RoutePage()
class BiometricGatePage extends StatefulWidget implements AutoRouteWrapper {
  const BiometricGatePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return GetInWidget(
      dependencies: [GetIn<GatewayController>(GatewayController.new)],
      child: this,
    );
  }

  @override
  State<BiometricGatePage> createState() => _BiometricGatePageState();
}

class _BiometricGatePageState extends State<BiometricGatePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    // Auto-trigger auth
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _authenticate() {
    Get.find<GatewayController>().authenticate(
      onBiometricsUnsupported: _navigateToMasterKey,
      onSuccess: _navigateToMasterKey,
    );
  }

  void _navigateToMasterKey() {
    if (!mounted) {
      return;
    }
    context.router.replace(
      MasterKeyRoute(onAuthenticated: _onMasterKeyValidated),
    );
  }

  void _onMasterKeyValidated(BuildContext context, String masterKey) {
    final GatewayController controller = Get.find<GatewayController>();
    controller.onMasterKeyValidated(
      masterKey,
      onReady: (VaultRepoImpl repository) {
        if (!mounted) {
          return;
        }
        context.router.replace(VaultRoute(repository: repository));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final GatewayController controller = Get.find<GatewayController>();
    return Scaffold(
      body: SafeArea(
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
                      animation: _pulseAnimation,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              (controller.state.authFailed
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.primary)
                                  .withAlpha(20),
                          border: Border.all(
                            color:
                                (controller.state.authFailed
                                        ? theme.colorScheme.error
                                        : theme.colorScheme.primary)
                                    .withAlpha(40),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          controller.state.authFailed
                              ? Icons.lock_outline_rounded
                              : Icons.fingerprint_rounded,
                          size: 52,
                          color: controller.state.authFailed
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Title
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      controller.state.authFailed
                          ? 'Authentication Failed'
                          : 'Verify Your Identity',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      controller.state.authFailed
                          ? 'Please try again to access your vault'
                          : 'Use biometrics or device PIN to\naccess your Password Vault',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Loading or retry
                  if (controller.state.isAuthenticating)
                    FadeIn(
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                          strokeWidth: 2.5,
                        ),
                      ),
                    )
                  else if (controller.state.authFailed)
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 52,
                            width: 180,
                            child: ElevatedButton(
                              onPressed: _authenticate,
                              child: const Text('TRY AGAIN'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => context.router.maybePop(),
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
    );
  }
}
