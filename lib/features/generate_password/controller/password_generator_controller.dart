import 'package:flutter/material.dart';
import 'package:rxget/rxget.dart';

import '../../../service/generate_password/domain/entities/password.dart';
import '../../../service/generate_password/domain/entities/password_settings.dart';
import '../../../service/generate_password/domain/use_cases/delete_password_use_case.dart';
import '../../../service/generate_password/domain/use_cases/get_password_history_use_case.dart';
import '../../../service/generate_password/domain/use_cases/pasword_use_case.dart';
import '../../../service/generate_password/domain/use_cases/save_password_use_case.dart';

part 'password_generator_state.dart';

class PasswordGeneratorController
    extends GetxController<_PasswordGeneratorState> {
  PasswordGeneratorController({
    required this.generatePasswordUseCase,
    required this.deletePasswordHistoryUseCase,
    required this.getPasswordHistoryUseCase,
    required this.savePasswordUseCase,
  }) : state = _PasswordGeneratorState();

  final GeneratePasswordUseCase generatePasswordUseCase;
  final DeletePasswordHistoryUseCase deletePasswordHistoryUseCase;
  final GetPasswordHistoryUseCase getPasswordHistoryUseCase;
  final SavePasswordUseCase savePasswordUseCase;

  @override
  final _PasswordGeneratorState state;

  void changePasswordLength(int length) => _changePasswordLength(length);
  void toggleLowercase() => _toggleLowercase();
  void toggleUppercase() => _toggleUppercase();
  void toggleNumbers() => _toggleNumbers();
  void toggleSymbols() => _toggleSymbols();
  void toggleExcludeDuplicate() => _toggleExcludeDuplicate();
  void toggleIncludeSpaces() => _toggleIncludeSpaces();
  void generatePassword() => _generatePassword();
  void savePassword() => _savePassword();
  void getPasswordHistory() => _getPasswordHistory();
  void deletePasswordHistory() => _deletePasswordHistory();

  void _changePasswordLength(int length) {
    state._passwordLength.value = length;
  }

  void _toggleLowercase() {
    if (!state.isLowercase ||
        state.isLowercase && state.isUppercase ||
        state.isLowercase && state.isNumbers ||
        state.isLowercase && state.isSymbols) {
      state._isLowercase.value = !state.isLowercase;
      _updateMaxPasswordLength();
    }
  }

  void _toggleUppercase() {
    if (!state.isUppercase ||
        state.isUppercase && state.isLowercase ||
        state.isUppercase && state.isNumbers ||
        state.isUppercase && state.isSymbols) {
      state._isUppercase.value = !state.isUppercase;
      _updateMaxPasswordLength();
    }
  }

  void _toggleNumbers() {
    if (!state.isNumbers ||
        state.isNumbers && state.isLowercase ||
        state.isNumbers && state.isUppercase ||
        state.isNumbers && state.isSymbols) {
      state._isNumbers.value = !state.isNumbers;
      _updateMaxPasswordLength();
    }
  }

  void _toggleSymbols() {
    if (!state.isSymbols ||
        state.isSymbols && state.isLowercase ||
        state.isSymbols && state.isUppercase ||
        state.isSymbols && state.isNumbers) {
      state._isSymbols.value = !state.isSymbols;
      _updateMaxPasswordLength();
    }
  }

  void _toggleExcludeDuplicate() {
    state._isExcludeDuplicate.value = !state.isExcludeDuplicate;
  }

  void _toggleIncludeSpaces() {
    state._isIncludeSpaces.value = !state.isIncludeSpaces;
    _updateMaxPasswordLength();
  }

  void _updateMaxPasswordLength() {
    int max = 0;
    if (state.isLowercase) {
      max += 12;
    }
    if (state.isUppercase) {
      max += 12;
    }
    if (state.isNumbers) {
      max += 10;
    }
    if (state.isSymbols) {
      max += 12;
    }
    if (state.isIncludeSpaces) {
      max += 2;
    }

    state._maxPasswordLength.value = max;
    if (state.passwordLength > max) {
      state._passwordLength.value = max;
    }
  }

  void _generatePassword() {
    final PasswordSettings params = PasswordSettings(
      passwordLength: state.passwordLength,
      withLowercase: state.isLowercase,
      withUppercase: state.isUppercase,
      withSymbols: state.isSymbols,
      withNumbers: state.isNumbers,
      excludeDuplicates: state.isExcludeDuplicate,
      includeSpaces: state.isIncludeSpaces,
    );

    final String randomPassword = generatePasswordUseCase.call(params);
    state.passwordController.text = randomPassword;
    state._generatedPassword.value = randomPassword;
  }

  void _savePassword() {
    if (state.passwordController.text.isNotEmpty) {
      savePasswordUseCase.call(
        Password(
          date: DateTime.now(),
          password: state.passwordController.text,
        ),
      );
    }
  }

  void _getPasswordHistory() {
    final List<Password> history = getPasswordHistoryUseCase.call(null);
    state._passwordHistory.assignAll(history);
  }

  void _deletePasswordHistory() {
    deletePasswordHistoryUseCase.call(null);
    state._passwordHistory.clear();
  }
}
