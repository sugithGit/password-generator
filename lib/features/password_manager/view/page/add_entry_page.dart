import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/const/constants.dart';
import '../../../../service/password_manager/domain/entities/vault_entry.dart';
import '../../bloc/vault_bloc.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({this.existingEntry, super.key});

  final VaultEntry? existingEntry;

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
    if (e != null) _selectedCategory = e.category;
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
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();

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
      context.read<VaultBloc>().add(UpdateEntry(entry: updated));
    } else {
      context.read<VaultBloc>().add(
            AddEntry(
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
            ),
          );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Title
                      _buildField(
                        controller: _titleController,
                        label: 'Title',
                        icon: Icons.title_rounded,
                        hint: 'e.g. Gmail, Instagram',
                        validator: (String? v) =>
                            v == null || v.isEmpty ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 16),
                      // Username/Email
                      _buildField(
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
                      _buildField(
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
                      _buildField(
                        controller: _websiteController,
                        label: 'Website (optional)',
                        icon: Icons.language_rounded,
                        hint: 'e.g. https://gmail.com',
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 16),
                      // Notes
                      _buildField(
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
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: VaultCategory.values.map(
                          (VaultCategory cat) {
                            final bool isSelected = _selectedCategory == cat;
                            final Color color = _getCategoryColor(cat);
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedCategory = cat),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withAlpha(30)
                                      : theme.cardColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color:
                                        isSelected ? color : theme.dividerColor,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      _getCategoryIcon(cat),
                                      color: isSelected
                                          ? color
                                          : theme.colorScheme.onSurfaceVariant,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      cat.label,
                                      style: TextStyle(
                                        color: isSelected
                                            ? color
                                            : theme
                                                .colorScheme.onSurfaceVariant,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(height: 40),
                      // Save button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _save,
                          child: Text(
                            _isEditing ? 'UPDATE PASSWORD' : 'SAVE PASSWORD',
                          ),
                        ),
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
                                        color: theme.colorScheme.onSurface),
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete this entry?',
                                    style: TextStyle(
                                        color:
                                            theme.colorScheme.onSurfaceVariant),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: theme
                                                .colorScheme.onSurfaceVariant),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<VaultBloc>().add(
                                              DeleteEntry(
                                                entryId:
                                                    widget.existingEntry!.id,
                                              ),
                                            );
                                        Navigator.of(ctx).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: theme.colorScheme.error),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.error,
                              side: BorderSide(
                                  color:
                                      theme.colorScheme.error.withAlpha(100)),
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: theme.dividerColor,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: theme.colorScheme.onSurface,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            _isEditing ? 'Edit Password' : 'Add Password',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Icon(icon, size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 44),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Color _getCategoryColor(VaultCategory cat) {
    switch (cat) {
      case VaultCategory.social:
        return categorySocial;
      case VaultCategory.email:
        return categoryEmail;
      case VaultCategory.banking:
        return categoryBanking;
      case VaultCategory.shopping:
        return categoryShopping;
      case VaultCategory.work:
        return categoryWork;
      case VaultCategory.other:
        return categoryOther;
    }
  }

  IconData _getCategoryIcon(VaultCategory cat) {
    switch (cat) {
      case VaultCategory.social:
        return Icons.people_outline_rounded;
      case VaultCategory.email:
        return Icons.email_outlined;
      case VaultCategory.banking:
        return Icons.account_balance_outlined;
      case VaultCategory.shopping:
        return Icons.shopping_bag_outlined;
      case VaultCategory.work:
        return Icons.work_outline_rounded;
      case VaultCategory.other:
        return Icons.key_rounded;
    }
  }
}
