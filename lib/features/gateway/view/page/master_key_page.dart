import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_rxget/hooks_rxget.dart';
import 'package:rxget/rxget.dart';

import '../../../../core/db/hive/user_prefs_local.dart';
import '../../../../core/routes/app_router.gr.dart';
import '../../controller/gateway/gateway_controller.dart';
import '../widgets/master_key_back_button.dart';
import '../widgets/master_key_form_card.dart';
import '../widgets/master_key_header.dart';

/// Page prompting the user to enter (or setup) their master key.
///
/// First-time users: Creates a verification hash stored in Firestore.
/// Returning users: Validates master key against stored hash.
///
/// If the master key is lost, data is irrecoverable — this is by design.
@RoutePage()
class MasterKeyPage extends HookWidget {
  const MasterKeyPage({super.key});

  @override
  Widget build(BuildContext context) {
    useGetIn<GatewayController>(GetIn(GatewayController.new));
    final GatewayController controller = Get.find<GatewayController>();

    final masterKeyController = useTextEditingController();
    final confirmController = useTextEditingController();

    // We use a traditional GlobalKey for the form
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final void Function(String) handleAuthError = useCallback((String error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
        context.router.replace(const LoginRoute());
      }
    }, <Object?>[context]);

    final void Function(String) handleSuccess = useCallback((
      String masterKey,
    ) async {
      if (!context.mounted) {
        return;
      }

      final bool isBiometricSupported = await controller.isBiometricsSupported;
      final UserPrefsLocal userPrefs = UserPrefsLocal();

      if (!context.mounted) {
        return;
      }

      if (isBiometricSupported) {
        final bool? shouldEnable = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Enable Biometrics'),
              content: const Text(
                'Would you like to enable biometric unlock for quicker access next time?',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );

        await userPrefs.saveUseUnlock(useUnlock: shouldEnable ?? false);
      } else {
        await userPrefs.saveUseUnlock(useUnlock: false);
      }

      if (!context.mounted) {
        return;
      }

      await controller.onMasterKeyValidated(
        masterKey,
        onReady: (repository) {
          if (context.mounted) {
            context.router.replace(VaultRoute(repository: repository));
          }
        },
        onError: handleAuthError,
      );
    }, <Object?>[context, controller, handleAuthError]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.initMasterKey(
          onRequiresMasterKeyCreation: () {},
          onRequiresMasterKeyInput: () {},
          onSuccess: handleSuccess,
          onAuthError: handleAuthError,
        );
      });
      return null;
    }, const <Object?>[]);

    final VoidCallback submit = useCallback(
      () async {
        if (!formKey.currentState!.validate()) {
          return;
        }
        await HapticFeedback.mediumImpact();

        await controller.submitMasterKey(
          masterKey: masterKeyController.text.trim(),
          onSuccess: handleSuccess,
          onAuthError: handleAuthError,
        );
      },
      <Object?>[
        controller,
        masterKeyController,
        formKey,
        handleAuthError,
        handleSuccess,
      ],
    );

    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Obx(() {
                if (controller.state.isLoading &&
                    masterKeyController.text.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                      strokeWidth: 2.5,
                    ),
                  );
                }

                return Column(
                  children: <Widget>[
                    MasterKeyHeader(isNewUser: controller.state.isNewUser),
                    const SizedBox(height: 32),
                    MasterKeyFormCard(
                      controller: controller,
                      masterKeyController: masterKeyController,
                      confirmController: confirmController,
                      formKey: formKey,
                      submit: submit,
                    ),
                    const SizedBox(height: 24),
                    const MasterKeyBackButton(),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
