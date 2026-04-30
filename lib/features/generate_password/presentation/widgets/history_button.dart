import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/const/constants.dart';
import '../../../../core/services/encryption_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/page/login_page.dart';
import '../../../password_manager/presentation/page/biometric_gate_page.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({
    required this.encryptionService,
    super.key,
  });

  final EncryptionService encryptionService;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Tooltip(
        margin: const EdgeInsets.only(top: 10),
        message: 'Password Vault',
        child: InkWell(
          onTap: () => _handleTap(context),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  vaultAccent.withAlpha(30),
                  vaultGradientEnd.withAlpha(20),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                width: 2,
                color: vaultAccent.withAlpha(60),
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.all(defaultPadding),
            child: Icon(
              Icons.shield_rounded,
              color: Colors.white.withValues(alpha: 0.8),
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
