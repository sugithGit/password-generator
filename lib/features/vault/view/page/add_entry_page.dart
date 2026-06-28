import 'package:auto_route/auto_route.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxget/rxget.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bar/page_app_bar.dart';
import '../../../../core/widgets/app_button/app_button.dart';
import '../../../../service/password_manager/domain/entities/vault_category.dart';
import '../../../../service/password_manager/domain/entities/vault_entry.dart';
import '../../controller/add_password/add_password_controller.dart';
import '../../controller/vault/vault_controller.dart';
import '../widgets/add_password_category.dart';
import '../widgets/custom_form_field.dart';

@RoutePage()
class AddEntryPage extends HookWidget implements AutoRouteWrapper {
  const AddEntryPage({this.existingEntry, this.initialCategory, super.key});

  final VaultEntry? existingEntry;
  final VaultCategory? initialCategory;

  @override
  Widget wrappedRoute(BuildContext context) {
    return GetInWidget(
      dependencies: <GetIn<dynamic>>[
        GetIn<AddPasswordController>(
          () => AddPasswordController(
            selectedCategory:
                initialCategory ??
                existingEntry?.category ??
                VaultCategory.other,
            repository: Get.find<VaultController>().repository,
          ),
        ),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = existingEntry != null;
    final VaultEntry? e = existingEntry;

    final GlobalKey<FormState> formKey = useMemoized(GlobalKey<FormState>.new);
    final TextEditingController titleController = useTextEditingController(
      text: e?.title ?? '',
    );
    final TextEditingController usernameController = useTextEditingController(
      text: e?.username ?? '',
    );
    final TextEditingController passwordController = useTextEditingController(
      text: e?.encryptedPassword ?? '',
    );
    final TextEditingController websiteController = useTextEditingController(
      text: e?.website ?? '',
    );
    final TextEditingController notesController = useTextEditingController(
      text: e?.notes ?? '',
    );
    final ValueNotifier<bool> obscurePassword = useState(true);

    final AddPasswordController controller = Get.find<AddPasswordController>();

    useEffect(() {
      void listener() {
        controller.enableBtn(
          title: titleController.text,
          password: passwordController.text,
        );
      }

      titleController.addListener(listener);
      passwordController.addListener(listener);

      listener();

      return () {
        titleController.removeListener(listener);
        passwordController.removeListener(listener);
      };
    }, <Object?>[titleController, passwordController, controller]);

    final VoidCallback save = useCallback(
      () {
        if (!formKey.currentState!.validate()) {
          return;
        }
        HapticFeedback.mediumImpact();

        if (isEditing) {
          final VaultEntry updated = existingEntry!.copyWith(
            title: titleController.text.trim(),
            username: usernameController.text.trim(),
            encryptedPassword: passwordController.text.trim(),
            website: websiteController.text.trim().isNotEmpty
                ? websiteController.text.trim()
                : null,
            notes: notesController.text.trim().isNotEmpty
                ? notesController.text.trim()
                : null,
            category: controller.state.selectedCategory,
            updatedAt: DateTime.now(),
          );
          controller.updateEntry(updated);
        } else {
          controller.addEntry(
            title: titleController.text.trim(),
            username: usernameController.text.trim(),
            password: passwordController.text.trim(),
            website: websiteController.text.trim().isNotEmpty
                ? websiteController.text.trim()
                : null,
            notes: notesController.text.trim().isNotEmpty
                ? notesController.text.trim()
                : null,
            category: controller.state.selectedCategory,
          );
        }
        context.router.maybePop();
      },
      <Object?>[
        isEditing,
        existingEntry,
        titleController,
        usernameController,
        passwordController,
        websiteController,
        notesController,
        controller,
        context.router,
      ],
    );

    return Scaffold(
      appBar: PageAppBar(title: isEditing ? 'Edit Password' : 'Add Password'),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Title
                    CustomFormField(
                      controller: titleController,
                      label: 'Title',
                      icon: Icons.title_rounded,
                      hint: 'e.g. Gmail, Instagram',
                      validator: (String? v) =>
                          v == null || v.isEmpty ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 16),
                    // Username/Email
                    CustomFormField(
                      controller: usernameController,
                      label: 'Username / Email',
                      icon: Icons.person_outline_rounded,
                      hint: 'e.g. john@example.com',
                    ),
                    const SizedBox(height: 16),
                    // Password
                    CustomFormField(
                      controller: passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline_rounded,
                      hint: 'Enter password',
                      obscureText: obscurePassword.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: context.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        onPressed: () {
                          obscurePassword.value = !obscurePassword.value;
                        },
                      ),
                      validator: (String? v) => v == null || v.isEmpty
                          ? 'Password is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Website
                    CustomFormField(
                      controller: websiteController,
                      label: 'Website (optional)',
                      icon: Icons.language_rounded,
                      hint: 'e.g. https://gmail.com',
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    // Notes
                    CustomFormField(
                      controller: notesController,
                      label: 'Notes (optional)',
                      icon: Icons.notes_rounded,
                      hint: 'Add any notes...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    // Category
                    Text(
                      'CATEGORY',
                      style: context.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const AddPasswordCategory(),
                    const SizedBox(height: 40),
                    // Save button
                    Obx(
                      () => AppButton(
                        onPressed: save,
                        disabled: !controller.state.enableBtn,
                        title: isEditing ? 'UPDATE PASSWORD' : 'SAVE PASSWORD',
                      ),
                    ),
                    if (isEditing) ...<Widget>[
                      const SizedBox(height: 16),
                      // Delete button
                      SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            HapticFeedback.heavyImpact();
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) => AlertDialog(
                                backgroundColor: AppColors.card,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: const Text('Delete Password'),
                                content: const Text(
                                  'Are you sure you want to delete this entry?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => ctx.router.maybePop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.find<AddPasswordController>()
                                          .deleteEntry(existingEntry!.id);
                                      ctx.router.maybePop();
                                      context.router.maybePop();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'DELETE PASSWORD',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
