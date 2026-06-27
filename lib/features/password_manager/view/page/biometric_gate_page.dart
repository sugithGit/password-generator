import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxget/rxget.dart';
import 'package:sodium/sodium.dart';

import '../../../../service/auth/data/local/biometric_local.dart';
import '../../../../service/auth/data/repositories/biometric_repo_impl.dart';
import '../../../../service/auth/domain/repositories/biometric_repo.dart';
import '../../../../service/auth/domain/repositories/encryption_repo.dart';
import '../../../../service/auth/domain/use_cases/authenticate_biometrics_use_case.dart';
import '../../../../service/auth/domain/use_cases/check_biometrics_support_use_case.dart';
import '../../../../service/password_manager/data/remote/vault_remote_datasource.dart';
import '../../../../service/password_manager/data/repositories/vault_repo_impl.dart';
import '../../controller/vault_controller.dart';
import 'master_key_page.dart';
import 'vault_page.dart';

class BiometricGatePage extends StatefulWidget {
  const BiometricGatePage({required this.encryptionRepo, super.key});

  final EncryptionRepo encryptionRepo;

  @override
  State<BiometricGatePage> createState() => _BiometricGatePageState();
}

class _BiometricGatePageState extends State<BiometricGatePage>
    with SingleTickerProviderStateMixin {
  late final BiometricRepo _biometricRepo;
  late final CheckBiometricsSupportUseCase _checkBiometricsSupportUseCase;
  late final AuthenticateBiometricsUseCase _authenticateBiometricsUseCase;

  bool _isAuthenticating = false;
  bool _authFailed = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _biometricRepo = BiometricRepoImpl(biometricLocal: BiometricLocal());
    _checkBiometricsSupportUseCase =
        CheckBiometricsSupportUseCase(_biometricRepo);
    _authenticateBiometricsUseCase =
        AuthenticateBiometricsUseCase(_biometricRepo);

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

    final bool isSupported = await _checkBiometricsSupportUseCase.call(null);

    if (!isSupported) {
      // If device doesn't support biometrics, skip to master key
      if (mounted) {
        _navigateToMasterKey();
      }
      return;
    }

    final bool success = await _authenticateBiometricsUseCase
        .call('Authenticate to access your Password Vault');

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
          encryptionRepo: widget.encryptionRepo,
          onAuthenticated: _onMasterKeyValidated,
        ),
      ),
    );
  }

  void _onMasterKeyValidated(BuildContext context, String masterKey) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    // Derive the encryption key from UID + master key
    final SecureKey encryptionKey = widget.encryptionRepo.deriveKey(
      uid: user.uid,
      masterKey: masterKey,
    );

    final VaultRemoteDatasource datasource = VaultRemoteDatasource(
      userId: user.uid,
    );
    final VaultRepoImpl repository = VaultRepoImpl(
      remoteDatasource: datasource,
      encryptionRepo: widget.encryptionRepo,
      encryptionKey: encryptionKey,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => GetInWidget(
          dependencies: <GetIn<dynamic>>[
            GetIn<VaultController>(
              () => VaultController(repository: repository)..loadVault(),
            ),
          ],
          child: const VaultPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
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
                        color: (_authFailed
                                ? theme.colorScheme.error
                                : theme.colorScheme.primary)
                            .withAlpha(20),
                        border: Border.all(
                          color: (_authFailed
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.primary)
                              .withAlpha(40),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        _authFailed
                            ? Icons.lock_outline_rounded
                            : Icons.fingerprint_rounded,
                        size: 52,
                        color: _authFailed
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
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
                    style: theme.textTheme.headlineMedium?.copyWith(
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
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Loading or retry
                if (_isAuthenticating)
                  FadeIn(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                else if (_authFailed)
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 52,
                          width: 180,
                          child: ElevatedButton(
                            onPressed: _authenticate,
                            child: const Text('TRY AGAIN'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Go Back'),
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
