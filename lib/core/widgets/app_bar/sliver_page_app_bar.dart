import 'package:flutter/material.dart';

import '../back_btn.dart';

class SliverPageAppBar extends StatelessWidget {
  const SliverPageAppBar({
    this.title,
    this.actions,
    this.centerTitle = true,
    this.floating = false,
    super.key,
  });
  final String? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool floating;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: floating,
      leading: const BackBtn(),
      centerTitle: centerTitle,
      title: title != null
          ? Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: .w600,
                letterSpacing: .4,
              ),
            )
          : null,
      actions: actions,
    );
  }
}
