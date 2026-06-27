import 'package:flutter/material.dart';

import '../../../../core/const/constants.dart';

class InfoText extends StatelessWidget {
  const InfoText({
    required this.text,
    required this.show,
    super.key,
  });
  final bool show;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: show ? secondaryColor : Colors.transparent,
      ),
      textAlign: TextAlign.center,
    );
  }
}
