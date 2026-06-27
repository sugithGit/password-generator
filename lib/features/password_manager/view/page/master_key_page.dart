import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../service/auth/domain/repositories/encryption_repo.dart';

/// Page prompting the user to enter (or setup) their master key.
///
/// First-time users: Creates a verification hash stored in Firestore.
/// Returning users: Validates master key against stored hash.
///
/// If the master key is lost, data is irrecoverable — this is by design.
class MasterKeyPage extends StatefulWidget {
  const MasterKeyPage({
    required this.encryptionRepo,
    required this.onAuthenticated,
    super.key,
  });

  final EncryptionRepo encryptionRepo;

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
            !doc.data()!.containsKey('verificationHash');
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
          widget.encryptionRepo.createVerificationHash(
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
      final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      final String? storedHash = doc.data()?['verificationHash'] as String?;

      if (storedHash == null) {
        setState(() {
          _errorMessage =
              'Verification data not found. Please contact support.';
          _isLoading = false;
        });
        return;
      }

      final bool isValid = widget.encryptionRepo.verifyMasterKey(
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
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _isLoading && _masterKeyController.text.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
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
    final ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary.withAlpha(20),
            border: Border.all(
              color: theme.colorScheme.primary.withAlpha(40),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.key_rounded,
            size: 36,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _isNewUser ? 'Create Master Key' : 'Enter Master Key',
          style: theme.textTheme.headlineMedium?.copyWith(
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
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    color: Theme.of(context).colorScheme.error.withAlpha(15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.error.withAlpha(40),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Write this key down and keep it safe. It cannot be reset or recovered.',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .error
                                .withAlpha(200),
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                    color: Theme.of(context).colorScheme.error.withAlpha(15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.error.withAlpha(40),
                    ),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error.withAlpha(220),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 28),
              // Submit button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          _isNewUser ? 'CREATE VAULT' : 'UNLOCK VAULT',
                        ),
                ),
              ),
            ],
          ),
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
    final ThemeData theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildBackButton() {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Go Back'),
    );
  }
}
