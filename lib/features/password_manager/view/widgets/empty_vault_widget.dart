import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class EmptyVaultWidget extends StatelessWidget {
  const EmptyVaultWidget({required this.onAdd, super.key});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Animated vault icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withAlpha(15),
                  border: Border.all(
                    color: theme.colorScheme.primary.withAlpha(40),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: 44,
                  color: theme.colorScheme.primary.withAlpha(150),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Your vault is empty',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Add your first password to keep\nyour accounts secure',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              // Add button
              ElevatedButton.icon(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 52),
                ),
                icon: const Icon(Icons.add_rounded, size: 22),
                label: const Text('Add Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
