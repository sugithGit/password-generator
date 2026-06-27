import 'package:flutter/material.dart';

class VaultSearchBar extends StatelessWidget {
  const VaultSearchBar({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Search passwords...',
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 22,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 20,
                ),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
      ),
    );
  }
}
