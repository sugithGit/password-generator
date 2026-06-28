import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class MasterKeyBackButton extends StatelessWidget {
  const MasterKeyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.router.maybePop(),
      child: const Text('Go Back'),
    );
  }
}
