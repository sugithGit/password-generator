import 'package:flutter/material.dart';

import '../../controller/gateway/gateway_controller.dart';
import 'master_key_text_field.dart';

class MasterKeyFormCard extends StatelessWidget {
  const MasterKeyFormCard({
    required this.controller,
    required this.masterKeyController,
    required this.confirmController,
    required this.formKey,
    required this.submit,
    super.key,
  });

  final GatewayController controller;
  final TextEditingController masterKeyController;
  final TextEditingController confirmController;
  final GlobalKey<FormState> formKey;
  final VoidCallback submit;

  @override
  Widget build(BuildContext context) {
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
              MasterKeyTextField(
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
                MasterKeyTextField(
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
}
