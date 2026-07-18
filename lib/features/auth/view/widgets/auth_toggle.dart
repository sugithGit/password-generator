import 'package:flutter/material.dart';
import 'package:rxget/rxget.dart';

class AuthToggle extends StatelessWidget {
  const AuthToggle({required this.isSignUp, required this.onToggle, super.key});

  final bool isSignUp;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      behavior: .translucent,
      onTap: onToggle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            isSignUp ? 'Already have an account?' : "Don't have an account?",
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: onToggle,
            child: Text(isSignUp ? 'Sign In' : 'Sign Up'),
          ),
        ],
      ),
    );
  }
}
