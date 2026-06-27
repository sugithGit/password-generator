import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/const/constants.dart';

abstract final class AppSnackBar {
  static void call(BuildContext context) => _call(context);

  static void _call(BuildContext context) => toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        title: const Text("Successfully Copied to Clipboard"),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 4),
        primaryColor: cardColor2,
        backgroundColor: cardColor2,
        foregroundColor: primaryColor,
        showIcon: false,
        icon: const Icon(Iconsax.archive_1),
        dragToClose: true,
      );
}
