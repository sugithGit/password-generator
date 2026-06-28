import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxget/rxget.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/routes/app_router.gr.dart';
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
          context.router.replace(MasterKeyRoute());
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Obx(() {
                  final bool isSignUp = controller.state.isSignUp;
                  return Column(
                    children: <Widget>[
                      // ── Header ─────────────────────────────────
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: AuthHeader(isSignUp: isSignUp),
                      ),
                      const SizedBox(height: 40),
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
      ),
    );
  }
}
