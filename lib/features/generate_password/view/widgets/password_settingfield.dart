import 'package:flutter/material.dart';
import 'package:rxget/rxget.dart';

import '../../controller/password_generator_controller.dart';
import 'coustom_check_box.dart';

class PassWordSettingField extends StatelessWidget {
  const PassWordSettingField({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PasswordGeneratorController controller =
        Get.find<PasswordGeneratorController>();
    return Column(
      children: <Widget>[
        Text(
          'PASSWORD SETTINGS',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          final PasswordGeneratorState state = controller.state;
          return Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    CustomCheckBox(
                      label: 'LowerCase (a-z)',
                      value: state.isLowercase,
                      onChanged: controller.toggleLowercase,
                    ),
                    CustomCheckBox(
                      label: 'Numbers (0-9)',
                      value: state.isNumbers,
                      onChanged: controller.toggleNumbers,
                    ),
                    CustomCheckBox(
                      label: 'Exclude Duplicate',
                      value: state.isExcludeDuplicate,
                      onChanged: controller.toggleExcludeDuplicate,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    CustomCheckBox(
                      label: 'UpperCase (A-Z)',
                      value: state.isUppercase,
                      onChanged: controller.toggleUppercase,
                    ),
                    CustomCheckBox(
                      label: r'Symbols (!-$^+)',
                      value: state.isSymbols,
                      onChanged: controller.toggleSymbols,
                    ),
                    CustomCheckBox(
                      label: 'Include Spaces',
                      value: state.isIncludeSpaces,
                      onChanged: controller.toggleIncludeSpaces,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
