import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:rxget/rxget.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/routes/app_router.gr.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../controller/auth_controller.dart';
import '../widgets/auth_form_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_toggle.dart';

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

    return Obl(
      () {
        if (controller.state.status == .success) {
          context.router.replace(const MasterKeyRoute());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF3ECF8E), // Vibrant Supabase Green at the top
                Color(0xFF1B6A42), // Transition to dark green
                AppColors.background, // Fades perfectly into black
              ],
              stops: <double>[0, 0.14, 0.28],
            ),
          ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: AuthHeader(isSignUp: isSignUp),
                      ),
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
      ),
    );
  }
}
