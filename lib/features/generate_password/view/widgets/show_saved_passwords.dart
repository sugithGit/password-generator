import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/const/constants.dart';
import '../../../../core/extension/date_time_extension.dart';
import '../../../../service/generate_password/domain/entities/password.dart';
import '../../bloc/password_generate_bloc.dart';

abstract final class ShowSavedPasswords {
  static void call({
    required BuildContext context,
    required PasswordGenratorBloc bloc,
  }) =>
      _call(context, bloc);

  static void _call(
    BuildContext context,
    PasswordGenratorBloc bloc,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) => _SavedPaaswordBottomSheet(bloc),
    );
  }
}

class _SavedPaaswordBottomSheet extends StatelessWidget {
  const _SavedPaaswordBottomSheet(this.bloc);
  final PasswordGenratorBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: <Widget>[
          const _Indicator(),
          _Header(bloc),
          const SizedBox(height: defaultPadding),
          Expanded(
            child: BlocBuilder<PasswordGenratorBloc, PasswordGenratorState>(
              bloc: bloc,
              builder: (
                BuildContext context,
                PasswordGenratorState state,
              ) {
                return ListView.builder(
                  itemCount: state.passwordHistory.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _HistoryCard(
                      passwordHistory: state.passwordHistory[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: defaultPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurfaceVariant.withAlpha(80),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.passwordHistory,
  });
  final Password passwordHistory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  passwordHistory.password,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  passwordHistory.date.formattedDate,
                  style: context.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Copy',
              icon: Icon(
                Icons.copy,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: passwordHistory.password),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.bloc);
  final PasswordGenratorBloc bloc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          Text(
            'Password History',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          _ClearPasswordHistory(bloc),
        ],
      ),
    );
  }
}

class _ClearPasswordHistory extends StatelessWidget {
  const _ClearPasswordHistory(this.bloc);
  final PasswordGenratorBloc bloc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<PasswordGenratorBloc, PasswordGenratorState>(
      bloc: bloc,
      builder: (BuildContext context, PasswordGenratorState state) {
        final bool isEnabled = state.passwordHistory.isNotEmpty;
        return ElevatedButton(
          onPressed:
              isEnabled ? () => bloc.add(DeletePasswordHistoryEvent()) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled
                ? theme.colorScheme.error
                : theme.colorScheme.secondary,
            foregroundColor: isEnabled
                ? theme.colorScheme.onError
                : theme.colorScheme.onSurfaceVariant,
            disabledBackgroundColor: theme.colorScheme.secondary.withAlpha(100),
            disabledForegroundColor:
                theme.colorScheme.onSurfaceVariant.withAlpha(100),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: Size.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Clear All',
            style: context.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isEnabled
                  ? theme.colorScheme.onError
                  : theme.colorScheme.onSurfaceVariant.withAlpha(100),
            ),
          ),
        );
      },
    );
  }
}
