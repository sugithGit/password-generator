import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/const/constants.dart';
import '../bloc/password_generate_bloc.dart';

class PasswordButton extends StatelessWidget {
  const PasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    void generatePassword() {
      HapticFeedback.heavyImpact();
      context
          .read<PasswordGenratorBloc>()
          .add(GeneratePasswordSubmittedEvent());
    }

    void copyPassword(String password, BuildContext context) {
      if (password.isNotEmpty) {
        HapticFeedback.mediumImpact();
        Clipboard.setData(
          ClipboardData(text: password),
        );
        // setState(() {
        //   borderColor = const Color.fromRGBO(224, 224, 224, 0.293);
        // });
        // Timer(
        //   const Duration(milliseconds: 300),
        //   () => setState(() {
        //     borderColor = Colors.transparent;
        //   }),
        // );
        // AppSnackBar.call(context);
        context.read<PasswordGenratorBloc>().add(
              SavePasswordEvent(
                password: password,
              ),
            );
      }
    }

    return BlocBuilder<PasswordGenratorBloc, PasswordGenratorState>(
      builder: (
        BuildContext context,
        PasswordGenratorState state,
      ) {
        return Column(
          children: <Widget>[
            Text(
              'CREATE RANDOM PASSWORD',
              style: context.bodyLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white.withAlpha(50),
              ),
            ).paddingOnly(
              bottom: 10,
            ),
            Text(
              state.passwordController.text.isNotEmpty
                  ? state.passwordController.text
                  : '________',
              maxLines: 4,
              style: context.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2.5,
                color: state.passwordController.text.isNotEmpty
                    ? Colors.white
                    : Colors.white.withAlpha(50),
              ),
            ).paddingOnly(
              bottom: 30,
            ),
            if (state.passwordController.text.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton.filled(
                    onPressed: generatePassword,
                    icon: const SizedBox(
                      height: 30,
                      width: 30,
                      child: Icon(Iconsax.refresh),
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: cardColor2,
                    ),
                  ),
                  10.widthBox,
                  IconButton.filled(
                    onPressed: () {
                      copyPassword(
                        state.passwordController.text,
                        context,
                      );
                    },
                    icon: const Center(child: Text('COPY'))
                        .paddingSymmetric(vertical: 5, horizontal: 10),
                    style: IconButton.styleFrom(
                      backgroundColor: cardColor2,
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
                    icon: const Center(child: Text('GENERATE'))
                        .paddingSymmetric(vertical: 5, horizontal: 10),
                    style: IconButton.styleFrom(
                      backgroundColor: cardColor2,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
