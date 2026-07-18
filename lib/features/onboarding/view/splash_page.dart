import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rxget/rxget.dart';

import '../../../../core/db/hive/user_prefs_local.dart';
import '../../../../core/routes/app_router.gr.dart';
import '../../../../service/auth/domain/entities/auth_user.dart';
import '../../../../service/auth/domain/repositories/auth_repo.dart';
import '../../../../service/auth/domain/repositories/master_key_repo.dart';
import '../../generate_password/view/widgets/header.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  Future<void> _startTimer() async {
    final AuthRepo authRepo = Get.find<AuthRepo>();
    final AuthUser? user = authRepo.currentUser;

    final UserPrefsLocal userPrefs = UserPrefsLocal();
    final bool hasSeenOnboarding = await userPrefs.getHasSeenOnboarding();

    if (!hasSeenOnboarding) {
      await context.router.replaceAll([const OnboardingRoute()]);
      return;
    }

    if (user == null) {
      await context.router.replaceAll([const LoginRoute()]);
      return;
    }

    final MasterKeyRepo masterKeyRepo = Get.find<MasterKeyRepo>();
    final String? localMasterKey = await masterKeyRepo.getLocalMasterKey(
      user.uid,
    );

    if (localMasterKey == null) {
      await context.router.replaceAll([const MasterKeyRoute()]);
      return;
    }

    final bool useUnlock = await userPrefs.getUseUnlock();

    if (mounted) {
      if (useUnlock) {
        await context.router.replaceAll([const BiometricGateRoute()]);
      } else {
        await context.router.replaceAll([const MasterKeyRoute()]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: AppLogo()));
  }
}
