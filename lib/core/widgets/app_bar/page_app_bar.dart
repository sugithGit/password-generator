import 'package:flutter/material.dart';

import '../back_btn.dart';

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PageAppBar({
    super.key,
    this.title,
    this.actions,
    this.bg,
    this.centerTitle = true,
  });
  final String? title;
  final List<Widget>? actions;
  final Color? bg;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackBtn(),
      backgroundColor: bg,
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
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
