import 'package:flutter/material.dart';

import '../../../../core/widgets/empty_widget.dart';

class MasterKeyTextField extends StatelessWidget {
  const MasterKeyTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool isObsecure = obscureText ?? false;
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: controller,
          obscureText: isObsecure,
          validator: validator,
          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, size: 20),
            suffixIcon: obscureText != null
                ? IconButton(
                    icon: Icon(
                      isObsecure ? Icons.visibility : Icons.visibility_off,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        isObsecure = !isObsecure;
                      });
                    },
                  )
                : const Empty(),
          ),
        );
      },
    );
  }
}
