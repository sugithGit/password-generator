import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:rxget/rxget.dart';

import '../../controller/password_generator_controller.dart';

class PasswordButton extends StatelessWidget {
  const PasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    final PasswordGeneratorController controller =
        Get.find<PasswordGeneratorController>();

    void generatePassword() {
      HapticFeedback.heavyImpact();
      controller.generatePassword();
    }

    void copyPassword(String password) {
      if (password.isNotEmpty) {
        HapticFeedback.mediumImpact();
        Clipboard.setData(ClipboardData(text: password));
        controller.savePassword();
      }
    }

    return Obx(() {
      final state = controller.state;
      final ThemeData theme = Theme.of(context);
      final password = state.generatedPassword;
      return Column(
        children: <Widget>[
          Text(
            'CREATE RANDOM PASSWORD',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
            ),
          ).paddingOnly(bottom: 10),
          Text(
            password.isNotEmpty ? password : '________',
            maxLines: 4,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
              color: password.isNotEmpty
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withAlpha(50),
            ),
          ).paddingOnly(bottom: 30),
          if (password.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton.filled(
                  onPressed: generatePassword,
                  icon: SizedBox(
                    height: 30,
                    width: 30,
                    child: Icon(
                      Iconsax.refresh,
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                ),
                10.widthBox,
                IconButton.filled(
                  onPressed: () {
                    copyPassword(password);
                  },
                  icon: Center(
                    child: Text(
                      'COPY',
                      style: TextStyle(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ).paddingSymmetric(vertical: 5, horizontal: 10),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton.filled(
                  onPressed: generatePassword,
                  icon: Center(
                    child: Text(
                      'GENERATE',
                      style: TextStyle(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ).paddingSymmetric(vertical: 5, horizontal: 10),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }
}
