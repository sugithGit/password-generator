import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxget/rxget.dart';

import '../../../../service/password_manager/domain/entities/vault_entry.dart';
import '../../controller/vault/vault_controller.dart';

@RoutePage()
class ViewPasswordPage extends StatefulWidget {
  const ViewPasswordPage({required this.entry, super.key});

  final VaultEntry entry;

  @override
  State<ViewPasswordPage> createState() => _ViewPasswordPageState();
}

class _ViewPasswordPageState extends State<ViewPasswordPage> {
  bool _showPassword = false;

  void _copyToClipboard(String text, String label) {
    HapticFeedback.mediumImpact();
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final VaultController controller = Get.find<VaultController>();

    final String title = controller.decrypt(widget.entry.title);
    final String? username = widget.entry.username != null
        ? controller.decrypt(widget.entry.username!)
        : null;
    final String password = controller.decrypt(widget.entry.encryptedPassword);
    final String? website = widget.entry.website != null
        ? controller.decrypt(widget.entry.website!)
        : null;
    final String? notes = widget.entry.notes != null
        ? controller.decrypt(widget.entry.notes!)
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Password Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildInfoCard(
              theme,
              title: 'Title',
              value: title,
              onCopy: () => _copyToClipboard(title, 'Title'),
            ),
            if (username != null && username.isNotEmpty)
              _buildInfoCard(
                theme,
                title: 'Username',
                value: username,
                onCopy: () => _copyToClipboard(username, 'Username'),
              ),
            _buildPasswordCard(theme, password),
            if (website != null && website.isNotEmpty)
              _buildInfoCard(
                theme,
                title: 'Website',
                value: website,
                onCopy: () => _copyToClipboard(website, 'Website'),
              ),
            if (notes != null && notes.isNotEmpty)
              _buildInfoCard(
                theme,
                title: 'Notes',
                value: notes,
                onCopy: () => _copyToClipboard(notes, 'Notes'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    ThemeData theme, {
    required String title,
    required String value,
    required VoidCallback onCopy,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 20),
                onPressed: onCopy,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordCard(ThemeData theme, String password) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Password',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withAlpha(10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _showPassword ? password : '•' * 12,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 16,
                          fontFamily: 'monospace',
                          letterSpacing: _showPassword ? 1 : 4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 22),
                    onPressed: () => _copyToClipboard(password, 'Password'),
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
