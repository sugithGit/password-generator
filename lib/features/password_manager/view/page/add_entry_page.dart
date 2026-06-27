import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxget/rxget.dart';

import '../../../../core/widgets/app_bar/page_app_bar.dart';
import '../../../../core/widgets/app_button/app_button.dart';
import '../../../../service/password_manager/domain/entities/vault_entry.dart';
import '../../controller/add_password/add_password_controller.dart';
import '../../controller/vault/vault_controller.dart';
import '../widgets/add_password_category.dart';
import '../widgets/custom_form_field.dart';

@RoutePage()
class AddEntryPage extends StatefulWidget implements AutoRouteWrapper {
  const AddEntryPage({this.existingEntry, this.initialCategory, super.key});

  final VaultEntry? existingEntry;
  final VaultCategory? initialCategory;

  @override
  Widget wrappedRoute(BuildContext context) {
    return GetInWidget(
      dependencies: <GetIn<dynamic>>[
        GetIn<AddPasswordController>(
          () => AddPasswordController(
            selectedCategory: initialCategory ?? existingEntry?.category ?? VaultCategory.other,
            repository: Get.find<VaultController>().repository,
          ),
        ),
      ],
      child: this,
    );
  }

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _websiteController;
  late TextEditingController _notesController;
  VaultCategory _selectedCategory = VaultCategory.other;
  bool _obscurePassword = true;

  bool get _isEditing => widget.existingEntry != null;

  @override
  void initState() {
    super.initState();
    final VaultEntry? e = widget.existingEntry;
    _titleController = TextEditingController(text: e?.title ?? '');
    _usernameController = TextEditingController(text: e?.username ?? '');
    _passwordController = TextEditingController(
      text: e?.encryptedPassword ?? '',
    );
    _websiteController = TextEditingController(text: e?.website ?? '');
    _notesController = TextEditingController(text: e?.notes ?? '');
    if (e != null) {
      _selectedCategory = e.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    HapticFeedback.mediumImpact();

    final AddPasswordController controller = Get.find<AddPasswordController>();

    if (_isEditing) {
      final VaultEntry updated = widget.existingEntry!.copyWith(
        title: _titleController.text.trim(),
        username: _usernameController.text.trim(),
        encryptedPassword: _passwordController.text.trim(),
        website: _websiteController.text.trim().isNotEmpty
            ? _websiteController.text.trim()
            : null,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        category: _selectedCategory,
        updatedAt: DateTime.now(),
      );
      controller.updateEntry(updated);
    } else {
      controller.addEntry(
        title: _titleController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        website: _websiteController.text.trim().isNotEmpty
            ? _websiteController.text.trim()
            : null,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        category: _selectedCategory,
      );
    }
    context.router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: PageAppBar(title: _isEditing ? 'Edit Password' : 'Add Password'),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Title
                    CustomFormField(
                      controller: _titleController,
                      label: 'Title',
                      icon: Icons.title_rounded,
                      hint: 'e.g. Gmail, Instagram',
                      validator: (String? v) =>
                          v == null || v.isEmpty ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 16),
                    // Username/Email
                    CustomFormField(
                      controller: _usernameController,
                      label: 'Username / Email',
                      icon: Icons.person_outline_rounded,
                      hint: 'e.g. john@example.com',
                      validator: (String? v) => v == null || v.isEmpty
                          ? 'Username is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Password
                    CustomFormField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline_rounded,
                      hint: 'Enter password',
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        onPressed: () => setState(() {
                          _obscurePassword = !_obscurePassword;
                        }),
                      ),
                      validator: (String? v) => v == null || v.isEmpty
                          ? 'Password is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Website
                    CustomFormField(
                      controller: _websiteController,
                      label: 'Website (optional)',
                      icon: Icons.language_rounded,
                      hint: 'e.g. https://gmail.com',
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    // Notes
                    CustomFormField(
                      controller: _notesController,
                      label: 'Notes (optional)',
                      icon: Icons.notes_rounded,
                      hint: 'Add any notes...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    // Category
                    Text(
                      'CATEGORY',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const AddPasswordCategory(),
                    const SizedBox(height: 40),
                    // Save button
                    AppButton(
                      onPressed: _save,
                      disabled: true,
                      title: _isEditing ? 'UPDATE PASSWORD' : 'SAVE PASSWORD',
                    ),
                    if (_isEditing) ...<Widget>[
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
                                backgroundColor: theme.cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Text(
                                  'Delete Password',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to delete this entry?',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => ctx.router.maybePop(),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.find<AddPasswordController>().deleteEntry(
                                        widget.existingEntry!.id,
                                      );
                                      ctx.router.maybePop();
                                      context.router.maybePop();
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: theme.colorScheme.error,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                            side: BorderSide(
                              color: theme.colorScheme.error.withAlpha(100),
                            ),
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
