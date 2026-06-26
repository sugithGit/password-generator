import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/const/constants.dart';
import '../../../../core/extension/date_time_extension.dart';
import '../../../../service/generate_password/domain/entities/password.dart';
import '../bloc/password_generate_bloc.dart';

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
      backgroundColor: bottomSheetColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
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
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[600],
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
    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(passwordHistory.password),
                const SizedBox(height: 5),
                Text(
                  passwordHistory.date.formattedDate,
                  style: context.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Copy',
              icon: Icon(
                Icons.copy,
                color: Colors.white.withValues(alpha: 0.5),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          Text(
            'Password History',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
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
    return BlocBuilder<PasswordGenratorBloc, PasswordGenratorState>(
      bloc: bloc,
      builder: (BuildContext context, PasswordGenratorState state) {
        final bool isEnabled = state.passwordHistory.isNotEmpty;
        return ElevatedButton(
          onPressed:
              isEnabled ? () => bloc.add(DeletePasswordHistoryEvent()) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? null : Colors.grey[800],
            disabledBackgroundColor: Colors.grey[800],
            disabledForegroundColor: Colors.grey[600],
          ),
          child: Text(
            'Clear All',
            style: context.bodySmall?.copyWith(
              color: isEnabled ? null : Colors.grey[600],
            ),
          ),
        );
      },
    );
  }
}
