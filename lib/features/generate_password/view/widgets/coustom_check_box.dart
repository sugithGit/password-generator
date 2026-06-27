import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/const/constants.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });
  final String label;
  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(
        defaultPadding / 4,
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () {
          onChanged();
          HapticFeedback.lightImpact();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: defaultPadding,
          ),
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border.all(
              color: value
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
