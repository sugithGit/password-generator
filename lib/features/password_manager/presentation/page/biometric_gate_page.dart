import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sodium/sodium.dart';

import '../../../../core/const/constants.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/services/encryption_service.dart';
import '../../data/remote/vault_remote_datasource.dart';
import '../../data/repositories/vault_repo_impl.dart';
import '../bloc/vault_bloc.dart';
import 'master_key_page.dart';
import 'vault_page.dart';

class BiometricGatePage extends StatefulWidget {
  const BiometricGatePage({required this.encryptionService, super.key});

  final EncryptionService encryptionService;

  @override
  State<BiometricGatePage> createState() => _BiometricGatePageState();
}

class _BiometricGatePageState extends State<BiometricGatePage>
    with SingleTickerProviderStateMixin {
  final BiometricService _biometricService = BiometricService();
  bool _isAuthenticating = false;
  bool _authFailed = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    // Auto-trigger auth
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    setState(() {
      _isAuthenticating = true;
      _authFailed = false;
    });

    final bool isSupported = await _biometricService.isDeviceSupported();

    if (!isSupported) {
      // If device doesn't support biometrics, skip to master key
      if (mounted) _navigateToMasterKey();
      return;
    }

    final bool success = await _biometricService.authenticate();

    if (mounted) {
      setState(() {
        _isAuthenticating = false;
        _authFailed = !success;
      });
      if (success) {
        _navigateToMasterKey();
      }
    }
  }

  void _navigateToMasterKey() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => MasterKeyPage(
          encryptionService: widget.encryptionService,
          onAuthenticated: _onMasterKeyValidated,
        ),
      ),
    );
  }

  void _onMasterKeyValidated(String masterKey) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Derive the encryption key from UID + master key
    final SecureKey encryptionKey = widget.encryptionService.deriveKey(
      uid: user.uid,
      masterKey: masterKey,
    );

    final VaultRemoteDatasource datasource = VaultRemoteDatasource(
      userId: user.uid,
    );
    final VaultRepoImpl repository = VaultRepoImpl(
      remoteDatasource: datasource,
      encryptionService: widget.encryptionService,
      encryptionKey: encryptionKey,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<VaultBloc>(
          create: (_) =>
              VaultBloc(repository: repository)..add(const LoadVault()),
          child: const VaultPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Animated lock icon
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _authFailed
                              ? <Color>[
                                  vaultDanger.withAlpha(40),
                                  vaultDanger.withAlpha(20),
                                ]
                              : <Color>[
                                  vaultAccent.withAlpha(30),
                                  vaultGradientEnd.withAlpha(20),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: _authFailed
                              ? vaultDanger.withAlpha(60)
                              : vaultAccent.withAlpha(50),
                          width: 2,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: (_authFailed ? vaultDanger : vaultAccent)
                                .withAlpha(30),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        _authFailed
                            ? Icons.lock_outline_rounded
                            : Icons.fingerprint_rounded,
                        size: 52,
                        color: _authFailed
                            ? vaultDanger
                            : vaultAccent.withAlpha(200),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                // Title
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    _authFailed
                        ? 'Authentication Failed'
                        : 'Verify Your Identity',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    _authFailed
                        ? 'Please try again to access your vault'
                        : 'Use biometrics or device PIN to\naccess your Password Vault',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withAlpha(100),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Loading or retry
                if (_isAuthenticating)
                  FadeIn(
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        color: vaultAccent,
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                else if (_authFailed)
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: _authenticate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  vaultGradientStart,
                                  vaultGradientEnd,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: vaultAccent.withAlpha(40),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              'TRY AGAIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Go Back',
                            style: TextStyle(
                              color: Colors.white.withAlpha(100),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
