import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/password_generate_bloc.dart';
import 'coustom_check_box.dart';

class PassWordSettingField extends StatelessWidget {
  const PassWordSettingField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Text(
          'PASSWORD SETTINGS',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        BlocBuilder<PasswordGenratorBloc, PasswordGenratorState>(
          builder: (BuildContext context, PasswordGenratorState state) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      CustomCheckBox(
                        label: 'LowerCase (a-z)',
                        value: state.isLowercase,
                        onChanged: () => context
                            .read<PasswordGenratorBloc>()
                            .add(ChangeLowercaseEvent()),
                      ),
                      CustomCheckBox(
                        label: 'Numbers (0-9)',
                        value: state.isNumbers,
                        onChanged: () => context
                            .read<PasswordGenratorBloc>()
                            .add(ChangeNumbersEvnet()),
                      ),
                      CustomCheckBox(
                        label: 'Exclude Duplicate',
                        value: state.isExcludeDuplicate,
                        onChanged: () => context
                            .read<PasswordGenratorBloc>()
                            .add(ChangeExcludeDuplicateEvent()),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      CustomCheckBox(
                        label: 'UpperCase (A-Z)',
                        value: state.isUppercase,
                        onChanged: () => context
                            .read<PasswordGenratorBloc>()
                            .add(ChangeUppercaseEvent()),
                      ),
                      CustomCheckBox(
                        label: r'Symbols (!-$^+)',
                        value: state.isSymbols,
                        onChanged: () => context
                            .read<PasswordGenratorBloc>()
                            .add(ChangeSymbolsEvent()),
                      ),
                      CustomCheckBox(
                        label: 'Include Spaces',
                        value: state.isIncludeSpaces,
                        onChanged: () => context
                            .read<PasswordGenratorBloc>()
                            .add(ChangeIncludeSpacesEvent()),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
