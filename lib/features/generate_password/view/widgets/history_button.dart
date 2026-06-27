import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/const/constants.dart';
import '../../../../core/widgets/squircle.dart';
import '../../../../core/routes/app_router.gr.dart';
import '../../../../service/auth/domain/repositories/encryption_repo.dart';
import '../../../auth/view/page/login_page.dart';
import '../../../password_manager/view/page/biometric_gate_page.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
            decoration: ShapeDecoration(
              shape: const Squircle().shape(),
              color: theme.cardColor,
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
      context.router.push(const LoginRoute());
    } else {
      // Signed in → biometric gate → master key → vault
      context.router.push(const BiometricGateRoute());
    }
  }
}
