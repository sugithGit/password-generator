import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/db/hive/user_prefs_local.dart';
import '../../../../core/routes/app_router.gr.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_button/app_button.dart';

class _OnboardingSlide {
  _OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

@RoutePage()
class OnboardingPage extends HookWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = usePageController();
    final ValueNotifier<int> currentIndex = useState(0);

    final List<_OnboardingSlide> slides = <_OnboardingSlide>[
      _OnboardingSlide(
        title: 'Zero Knowledge',
        description:
            'Your data is yours alone. We cannot see, read, or decrypt your vault. Your master key never leaves your device.',
        icon: Icons.shield_rounded,
      ),
      _OnboardingSlide(
        title: 'Military-Grade\nEncryption',
        description:
            'Secured with XChaCha20-Poly1305 and Argon2id hashing, ensuring your passwords remain impenetrable.',
        icon: Icons.lock_person_rounded,
      ),
      _OnboardingSlide(
        title: 'Seamless &\nSecure',
        description:
            "Unlock your vault effortlessly with your device's biometrics. Security meets convenience.",
        icon: Icons.fingerprint_rounded,
      ),
    ];

    final VoidCallback onNext = useCallback(() {
      if (currentIndex.value < slides.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        UserPrefsLocal().saveHasSeenOnboarding(hasSeen: true);
        context.router.replaceAll([const LoginRoute()]);
      }
    }, <Object?>[currentIndex.value, pageController, context]);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 16),
                  child: TextButton(
                    onPressed: () {
                      UserPrefsLocal().saveHasSeenOnboarding(hasSeen: true);
                      context.router.replaceAll([const LoginRoute()]);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: const Text('Skip'),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (int index) {
                    currentIndex.value = index;
                  },
                  itemCount: slides.length,
                  itemBuilder: (BuildContext context, int index) {
                    final _OnboardingSlide slide = slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FadeInDown(
                            duration: const Duration(milliseconds: 600),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF3ECF8E).withAlpha(20),
                                border: Border.all(
                                  color: const Color(0xFF3ECF8E).withAlpha(40),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                slide.icon,
                                size: 80,
                                color: const Color(0xFF3ECF8E),
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 100),
                            child: Text(
                              slide.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 200),
                            child: Text(
                              slide.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary.withAlpha(180),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Bottom Section: Dots and Button
              Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: <Widget>[
                    // Dots indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(slides.length, (
                        int index,
                      ) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: currentIndex.value == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: currentIndex.value == index
                                ? const Color(0xFF3ECF8E)
                                : const Color(0xFF3ECF8E).withAlpha(60),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 300),
                      child: AppButton(
                        title: currentIndex.value == slides.length - 1
                            ? 'GET STARTED'
                            : 'NEXT',
                        onPressed: onNext,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
