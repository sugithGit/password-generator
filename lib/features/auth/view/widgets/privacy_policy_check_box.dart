import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PrivacyPolicyCheckBox extends StatelessWidget {
  const PrivacyPolicyCheckBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: context.width * 0.5,
          child: GestureDetector(
            onTap: () async {},
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: "I have read and accept the privacy policy.",
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: ' Privacy policy',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () async {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
