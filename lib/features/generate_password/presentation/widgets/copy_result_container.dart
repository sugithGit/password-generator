import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/const/constants.dart';
import '../bloc/password_generate_bloc.dart';
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
      Clipboard.setData(
        ClipboardData(text: password),
      );
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
      context.read<PasswordGenratorBloc>().add(
            SavePasswordEvent(
              password: password,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordGenratorBloc, PasswordGenratorState>(
      builder: (BuildContext context, PasswordGenratorState state) {
        return Column(
          children: <Widget>[
            InfoText(
              text: "Tap to Copy Password",
              show: state.passwordController.text.isNotEmpty,
            ),
            const SizedBox(height: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding + 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultPadding),
                color: trackBg,
              ),
              child: Stack(
                children: <Widget>[
                  TextField(
                    minLines: 1,
                    controller: state.passwordController,
                    readOnly: true,
                    style: const TextStyle(color: primaryColor, fontSize: 15),
                    decoration: const InputDecoration(
                      hintText: 'Password will appear here...',
                      hintStyle: TextStyle(color: secondaryColor, fontSize: 15),
                      border: InputBorder.none,
                    ),
                    onTap: () => _onTap(state.passwordController.text),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => _onTap(state.passwordController.text),
                      child: const Icon(
                        Icons.copy,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
