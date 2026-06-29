import 'package:flutter/material.dart';
import 'package:rxget/rxget.dart';
import '../../../../core/widgets/app_button/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../controller/auth_controller.dart';

class AuthFormCard extends StatelessWidget {
  const AuthFormCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isSignUp,
    required this.obscurePassword,
    required this.onObscurePressed,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSignUp;
  final bool obscurePassword;
  final VoidCallback onObscurePressed;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Email field
          AppTextField(
            controller: emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Password field
          AppTextField(
            controller: passwordController,
            label: 'Password',
            icon: Icons.lock_outline_rounded,
            obscureText: obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
              ),
              onPressed: onObscurePressed,
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 28),
          // Submit button
          Obx(() {
            final AuthController controller = Get.find<AuthController>();
            final bool isLoading = controller.state.isLoading;
            return AppButton(
              onPressed: isLoading ? null : onSubmit,
              title: isSignUp ? 'SIGN UP' : 'SIGN IN',
            );
          }),
        ],
      ),
    );
  }
}
