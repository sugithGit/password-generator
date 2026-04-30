import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local/password_gnerator.dart';
import '../../data/local/save_password.dart';
import '../../data/repositories/password_repo_impl.dart';
import '../../domain/use_cases/delete_password_use_case.dart';
import '../../domain/use_cases/get_password_history_use_case.dart';
import '../../domain/use_cases/pasword_use_case.dart';
import '../../domain/use_cases/save_password_use_case.dart';
import '../bloc/password_generate_bloc.dart';
import '../widgets/get_divider.dart';
import '../widgets/header.dart';
import '../widgets/history_button.dart';
import '../widgets/password_button.dart';
import '../widgets/password_length.dart';
import '../widgets/password_settingfield.dart';

import '../../../../core/services/encryption_service.dart';

class PasswordGeneratePage extends StatelessWidget {
  const PasswordGeneratePage({
    required this.encryptionService,
    super.key,
  });

  final EncryptionService encryptionService;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasswordGenratorBloc>(
      create: (BuildContext context) {
        final PasswordRepoImpl passwordRepo = PasswordRepoImpl(
          passwordGenerator: PasswordGenerator(),
          passwordHistoryLocal: PasswordHistoryLocal(),
        );
        return PasswordGenratorBloc(
          generatePasswordUseCase: GeneratePasswordUseCase(passwordRepo),
          deletePasswordHistoryUseCase:
              DeletePasswordHistoryUseCase(passwordRepo),
          getPasswordHistoryUseCase: GetPasswordHistoryUseCase(passwordRepo),
          savePasswordUseCase: SavePasswordUseCase(passwordRepo),
        );
      },
      child: _PassWordGeneratePage(encryptionService: encryptionService),
    );
  }
}

class _PassWordGeneratePage extends StatelessWidget {
  const _PassWordGeneratePage({required this.encryptionService});

  final EncryptionService encryptionService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (kIsWeb) const AppLogo(),
                    HistoryButton(encryptionService: encryptionService),
                    const PasswordLength(),
                    const SizedBox(height: 10),
                    const PassWordSettingField(),
                    const SizedBox(height: 20),
                    const GetDivider(),
                    const SizedBox(height: 20),
                    const PasswordButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
