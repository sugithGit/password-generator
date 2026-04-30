import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/const/constants.dart';
import '../../../../core/services/encryption_service.dart';

/// Page prompting the user to enter (or setup) their master key.
///
/// First-time users: Creates a verification hash stored in Firestore.
/// Returning users: Validates master key against stored hash.
///
/// If the master key is lost, data is irrecoverable — this is by design.
class MasterKeyPage extends StatefulWidget {
  const MasterKeyPage({
    required this.encryptionService,
    required this.onAuthenticated,
    super.key,
  });

  final EncryptionService encryptionService;

  /// Called with the validated master key when authentication succeeds.
  final void Function(String masterKey) onAuthenticated;

  @override
  State<MasterKeyPage> createState() => _MasterKeyPageState();
}

class _MasterKeyPageState extends State<MasterKeyPage> {
  final TextEditingController _masterKeyController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isNewUser = false;
  bool _obscureMasterKey = true;
  bool _obscureConfirm = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkIfNewUser();
  }

  @override
  void dispose() {
    _masterKeyController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _checkIfNewUser() async {
    setState(() => _isLoading = true);
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (mounted) {
      setState(() {
        _isNewUser = !doc.exists ||
            doc.data() == null ||
            !(doc.data()!.containsKey('verificationHash'));
        _isLoading = false;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final String masterKey = _masterKeyController.text.trim();

    if (_isNewUser) {
      // First time: store verification hash
      final String verificationHash =
          widget.encryptionService.createVerificationHash(
        uid: user.uid,
        masterKey: masterKey,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(<String, dynamic>{
        'verificationHash': verificationHash,
        'createdAt': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        widget.onAuthenticated(masterKey);
      }
    } else {
      // Returning user: validate master key
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      final String? storedHash = doc.data()?['verificationHash'] as String?;

      if (storedHash == null) {
        setState(() {
          _errorMessage = 'Verification data not found. Please contact support.';
          _isLoading = false;
        });
        return;
      }

      final bool isValid = widget.encryptionService.verifyMasterKey(
        uid: user.uid,
        masterKey: masterKey,
        storedVerificationHash: storedHash,
      );

      if (isValid) {
        if (mounted) widget.onAuthenticated(masterKey);
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Incorrect master key. Please try again.';
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _isLoading && _masterKeyController.text.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: vaultAccent,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        _buildHeader(),
                        const SizedBox(height: 40),
                        _buildFormCard(),
                        const SizedBox(height: 24),
                        _buildBackButton(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: <Widget>[
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: <Color>[vaultGradientStart, vaultGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: vaultAccent.withAlpha(60),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.key_rounded,
            size: 36,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _isNewUser ? 'Create Master Key' : 'Enter Master Key',
          style: context.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            _isNewUser
                ? 'This key encrypts all your data.\nStore it safely — if lost, your data cannot be recovered.'
                : 'Enter your master key to decrypt your vault.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withAlpha(100),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: vaultCardBg.withAlpha(180),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: vaultCardBorder.withAlpha(100),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_isNewUser) ...<Widget>[
              // Warning banner for new users
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: vaultWarning.withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: vaultWarning.withAlpha(40),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.warning_amber_rounded,
                      color: vaultWarning,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Write this key down and keep it safe. It cannot be reset or recovered.',
                        style: TextStyle(
                          color: vaultWarning.withAlpha(200),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            // Master key field
            _buildTextField(
              controller: _masterKeyController,
              label: 'Master Key',
              icon: Icons.key_rounded,
              obscureText: _obscureMasterKey,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureMasterKey
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white.withAlpha(100),
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscureMasterKey = !_obscureMasterKey),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Master key is required';
                }
                if (_isNewUser && value.length < 8) {
                  return 'Master key must be at least 8 characters';
                }
                return null;
              },
            ),
            if (_isNewUser) ...<Widget>[
              const SizedBox(height: 16),
              // Confirm field for new users
              _buildTextField(
                controller: _confirmController,
                label: 'Confirm Master Key',
                icon: Icons.key_off_rounded,
                obscureText: _obscureConfirm,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white.withAlpha(100),
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                validator: (String? value) {
                  if (value != _masterKeyController.text) {
                    return 'Master keys do not match';
                  }
                  return null;
                },
              ),
            ],
            if (_errorMessage != null) ...<Widget>[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: vaultDanger.withAlpha(15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: vaultDanger.withAlpha(40),
                  ),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: vaultDanger.withAlpha(220),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 28),
            // Submit button
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isLoading
                          ? <Color>[Colors.grey.shade800, Colors.grey.shade700]
                          : const <Color>[
                              vaultGradientStart,
                              vaultGradientEnd,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _isNewUser ? 'CREATE VAULT' : 'UNLOCK VAULT',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              letterSpacing: 1.5,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withAlpha(100),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: vaultAccent, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withAlpha(8),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: vaultCardBorder.withAlpha(80)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: vaultCardBorder.withAlpha(80)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: vaultAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: vaultDanger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: vaultDanger, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text(
        'Go Back',
        style: TextStyle(
          color: Colors.white.withAlpha(100),
          fontSize: 14,
        ),
      ),
    );
  }
}
