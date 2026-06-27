import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SvgPicture.asset(
      'assets/svg/password_generator_log.svg',
      colorFilter: ColorFilter.mode(
        theme.colorScheme.onSurface,
        BlendMode.srcIn,
      ),
      semanticsLabel: 'App Logo',
    ).paddingSymmetric(
      horizontal: 60,
    );
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     const SizedBox(height: 40),
    //     GradientText(
    //       'Password',
    //       style: const TextStyle(
    //         fontSize: 50,
    //         fontWeight: FontWeight.w900,
    //         letterSpacing: 1.5,
    //       ),
    //       colors: const <Color>[
    //         Color(0xFF2196F3),
    //         Color(0xFFF06292),
    //       ],
    //       radius: 2,
    //       gradientDirection: GradientDirection.rtl,
    //     ),
    //     GradientText(
    //       'Generator',
    //       style: const TextStyle(
    //         fontSize: 50,
    //         fontWeight: FontWeight.w900,
    //         letterSpacing: 1.5,
    //       ),
    //       colors: const <Color>[
    //         Color(0xFF2196F3),
    //         Color(0xFFF06292),
    //       ],
    //       radius: 2,
    //       gradientDirection: GradientDirection.rtl,
    //     ),
    //   ],
    // );
  }
}
