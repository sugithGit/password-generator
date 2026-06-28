import 'package:flutter/material.dart';

class MasterKeyHeader extends StatelessWidget {
  const MasterKeyHeader({required this.isNewUser, super.key});

  final bool isNewUser;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Icon(
          isNewUser ? Icons.security_rounded : Icons.lock_person_rounded,
          size: 64,
          color: theme.colorScheme.primary,
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
}
