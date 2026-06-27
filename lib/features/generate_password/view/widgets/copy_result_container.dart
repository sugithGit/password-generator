import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxget/rxget.dart';

import '../../../../core/const/constants.dart';
import '../../controller/password_generator_controller.dart';
import 'info_text.dart';

class CopyResultContainer extends StatefulWidget {
  const CopyResultContainer({super.key});

  @override
  State<CopyResultContainer> createState() => _CopyResultContainerState();
}

class _CopyResultContainerState extends State<CopyResultContainer> {
  bool isCopy = false;
  Color borderColor = Colors.transparent;

  void _onTap(String password) {
    if (password.isNotEmpty) {
      HapticFeedback.mediumImpact();
      Clipboard.setData(ClipboardData(text: password));
      setState(() {
        borderColor = const Color.fromRGBO(224, 224, 224, 0.293);
      });
      Timer(
        const Duration(milliseconds: 300),
        () => setState(() {
          borderColor = Colors.transparent;
        }),
      );
      // AppSnackBar.call(context);
      Get.find<PasswordGeneratorController>().savePassword();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PasswordGeneratorController controller =
        Get.find<PasswordGeneratorController>();
    return Obx(() {
      return Column(
        children: <Widget>[
          InfoText(
            text: "Tap to Copy Password",
            show: controller.state.passwordController.text.isNotEmpty,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: TextFormField(
              controller: controller.state.passwordController,
              readOnly: true,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'Password will appear here...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  onPressed: () =>
                      _onTap(controller.state.passwordController.text),
                ),
              ),
              onTap: () => _onTap(controller.state.passwordController.text),
            ),
          ),
        ],
      );
    });
  }
}
