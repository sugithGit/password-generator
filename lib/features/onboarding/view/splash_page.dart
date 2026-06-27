import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/services/encryption_service.dart';
import '../../generate_password/view/page/password_generate_page.dart';
import '../../generate_password/view/widgets/header.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({required this.encryptionService, super.key});

  final EncryptionService encryptionService;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<dynamic>(
            builder: (_) => PasswordGeneratePage(
              encryptionService: widget.encryptionService,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppLogo(),
      ),
    );
  }
}
