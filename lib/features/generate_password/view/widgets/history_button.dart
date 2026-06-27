import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/const/constants.dart';
import '../../../../core/services/encryption_service.dart';
import '../../../password_manager/view/page/biometric_gate_page.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/view/page/login_page.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({
    required this.encryptionService,
    super.key,
  });

  final EncryptionService encryptionService;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Tooltip(
        margin: const EdgeInsets.only(top: 10),
        message: 'Password Vault',
        child: InkWell(
          onTap: () => _handleTap(context),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border.all(
                width: 1.5,
                color: theme.dividerColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(defaultPadding),
            child: Icon(
              Icons.shield_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Not signed in → show login page
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider<AuthBloc>.value(
            value: context.read<AuthBloc>(),
            child: const LoginPage(),
          ),
        ),
      );
    } else {
      // Signed in → biometric gate → master key → vault
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BiometricGatePage(
            encryptionService: encryptionService,
          ),
        ),
      );
    }
  }
}
