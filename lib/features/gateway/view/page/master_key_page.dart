import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_rxget/hooks_rxget.dart';
import 'package:rxget/rxget.dart';

import '../../../../core/routes/app_router.gr.dart';
import '../../controller/gateway/gateway_controller.dart';

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

    final TextEditingController masterKeyController =
        useTextEditingController();
    final TextEditingController confirmController = useTextEditingController();

    // We use a traditional GlobalKey for the form
    final GlobalKey<FormState> formKey = useMemoized(GlobalKey<FormState>.new);

    final void Function(String) handleAuthError = useCallback((String error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
        context.router.replace(const LoginRoute());
      }
    }, <Object?>[context]);

    final void Function(String) handleSuccess = useCallback((String masterKey) {
      if (context.mounted) {
        controller.onMasterKeyValidated(
          masterKey,
          onReady: (repository) {
            if (context.mounted) {
              context.router.replace(VaultRoute(repository: repository));
            }
          },
          onError: handleAuthError,
        );
      }
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

        controller.submitMasterKey(
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
                    _buildHeader(context, controller.state.isNewUser),
                    const SizedBox(height: 40),
                    _buildFormCard(
                      context,
                      controller: controller,
                      masterKeyController: masterKeyController,
                      confirmController: confirmController,
                      formKey: formKey,
                      submit: submit,
                    ),
                    const SizedBox(height: 24),
                    _buildBackButton(context),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isNewUser) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary.withAlpha(20),
            border: Border.all(
              color: theme.colorScheme.primary.withAlpha(40),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.key_rounded,
            size: 36,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          isNewUser ? 'Create Master Key' : 'Enter Master Key',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            isNewUser
                ? 'This key encrypts all your data.\nStore it safely — if lost, your data cannot be recovered.'
                : 'Enter your master key to decrypt your vault.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard(
    BuildContext context, {
    required GatewayController controller,
    required TextEditingController masterKeyController,
    required TextEditingController confirmController,
    required GlobalKey<FormState> formKey,
    required VoidCallback submit,
  }) {
    final bool isNewUser = controller.state.isNewUser;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isNewUser) ...<Widget>[
                // Warning banner for new users
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withAlpha(15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.error.withAlpha(40),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Write this key down and keep it safe. It cannot be reset or recovered.',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.error.withAlpha(200),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              // Master key field
              _buildTextField(
                context,
                controller: masterKeyController,
                label: 'Master Key',
                icon: Icons.key_rounded,
                obscureText: controller.state.obscureMasterKey,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.state.obscureMasterKey
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: controller.toggleObscureMasterKey,
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Master key is required';
                  }
                  if (isNewUser && value.length < 8) {
                    return 'Master key must be at least 8 characters';
                  }
                  return null;
                },
              ),
              if (isNewUser) ...<Widget>[
                const SizedBox(height: 16),
                // Confirm field for new users
                _buildTextField(
                  context,
                  controller: confirmController,
                  label: 'Confirm Master Key',
                  icon: Icons.key_off_rounded,
                  obscureText: controller.state.obscureConfirm,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.state.obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: controller.toggleObscureConfirm,
                  ),
                  validator: (String? value) {
                    if (value != masterKeyController.text) {
                      return 'Master keys do not match';
                    }
                    return null;
                  },
                ),
              ],
              if (controller.state.errorMessage != null) ...<Widget>[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withAlpha(15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.error.withAlpha(40),
                    ),
                  ),
                  child: Text(
                    controller.state.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error.withAlpha(220),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 28),
              // Submit button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.state.isLoading ? null : submit,
                  child: controller.state.isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : Text(isNewUser ? 'CREATE VAULT' : 'UNLOCK VAULT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    final ThemeData theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return TextButton(
      onPressed: () => context.router.maybePop(),
      child: const Text('Go Back'),
    );
  }
}
