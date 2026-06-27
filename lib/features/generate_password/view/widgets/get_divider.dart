import 'package:flutter/material.dart';

import '../../../../core/const/constants.dart';

class GetDivider extends StatelessWidget {
  const GetDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: shade,
      thickness: .5,
      indent: 10,
      endIndent: 10,
    );
  }
}
