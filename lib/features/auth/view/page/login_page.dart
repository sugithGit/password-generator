import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:rxget/rxget.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/routes/app_router.gr.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_button/app_button.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../controller/auth_controller.dart';
import '../widgets/auth_form_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_toggle.dart';
import '../widgets/privacy_policy_check_box.dart';

@RoutePage()
class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final GlobalKey<FormState> formKey = useMemoized(GlobalKey<FormState>.new);
    final ValueNotifier<bool> obscurePassword = useState(true);

    final AuthController controller = Get.find<AuthController>();

    Future<void> submit() async {
      if (!formKey.currentState!.validate()) {
        return;
      }
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      try {
        await controller.sign(email: email, password: password);
      } on Exception catch (e) {
        if (context.mounted) {
          toastification.show(
            context: context,
            title: Text(
              controller.state.error ??
                  e.toString().replaceAll('Exception: ', ''),
            ),
            type: ToastificationType.error,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.flatColored,
          );
        }
      }
    }

    Future<void> loginWithGoogle() async {
      try {
        await controller.signInWithGoogle();
      } on Exception catch (e) {
        if (context.mounted) {
          toastification.show(
            context: context,
            title: Text(
              controller.state.error ??
                  e.toString().replaceAll('Exception: ', ''),
            ),
            type: ToastificationType.error,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.flatColored,
          );
        }
      }
    }

    return Obl(
      () {
        if (controller.state.status == .success) {
          context.router.replace(const MasterKeyRoute());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: AppBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                final bool isSignUp = controller.state.isSignUp;
                return Column(
                  children: <Widget>[
                    // ── Hero Text / Header ────────────────────────────
                    const SafeArea(child: Empty()),
                    const Gap(80),
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: AuthHeader(isSignUp: isSignUp),
                    ),
                    const SizedBox(height: 42),
                    // ── Glassmorphism card ─────────────────────
                    FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      child: AuthFormCard(
                        formKey: formKey,
                        emailController: emailController,
                        passwordController: passwordController,
                        isSignUp: isSignUp,
                        obscurePassword: obscurePassword.value,
                        onObscurePressed: () {
                          obscurePassword.value = !obscurePassword.value;
                        },
                        onSubmit: submit,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      duration: const Duration(milliseconds: 750),
                      child: Row(
                        children: <Widget>[
                          const Expanded(
                            child: Divider(
                              color: AppColors.border,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: AppColors.border,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: AppButton(
                        onPressed: controller.state.isLoading
                            ? null
                            : loginWithGoogle,
                        isLoading: controller.state.isLoading,
                        title: 'Sign in with Google',
                        bgColor: AppColors.card,
                        textColor: AppColors.foreground,
                        icon: SvgPicture.string(
                          _googleIconSvg,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // ── Toggle sign in / sign up ──────────────
                    FadeInUp(
                      child: AuthToggle(
                        isSignUp: isSignUp,
                        onToggle: controller.toggleSignUp,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        bottomNavigationBar: const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: PrivacyPolicyCheckBox(),
          ),
        ),
      ),
    );
  }
}

const String _googleIconSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
  <path fill="#EA4335" d="M5.266 9.765A7.077 7.077 0 0 1 12 4.909c1.69 0 3.218.6 4.418 1.582L19.91 3C17.782 1.145 15.055 0 12 0 7.33 0 3.29 2.69 1.34 6.622l3.926 3.143z"/>
  <path fill="#4285F4" d="M24 12.273c0-.873-.076-1.71-.22-2.518H12v4.8h6.73A5.752 5.752 0 0 1 16.2 18.28l3.837 2.973C22.28 19.26 24 16.04 24 12.273z"/>
  <path fill="#FBBC05" d="M5.266 14.235L1.34 17.378A11.968 11.968 0 0 0 12 24c3.055 0 5.782-1.145 7.91-3L16.2 18.027a7.073 7.073 0 0 1-9.434-3.792z"/>
  <path fill="#34A853" d="M5.266 9.765a7.073 7.073 0 0 1 0 4.47l-3.926 3.143a12.016 12.016 0 0 0 0-10.756l3.926 3.143z"/>
</svg>
''';
