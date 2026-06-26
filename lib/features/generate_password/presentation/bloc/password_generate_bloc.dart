import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../service/generate_password/domain/entities/password.dart';
import '../../../../service/generate_password/domain/entities/password_settings.dart';
import '../../../../service/generate_password/domain/use_cases/delete_password_use_case.dart';
import '../../../../service/generate_password/domain/use_cases/get_password_history_use_case.dart';
import '../../../../service/generate_password/domain/use_cases/pasword_use_case.dart';
import '../../../../service/generate_password/domain/use_cases/save_password_use_case.dart';

part 'password_generate_event.dart';
part 'password_generate_state.dart';

class PasswordGenratorBloc
    extends Bloc<PasswordGenratorEvent, PasswordGenratorState> {
  PasswordGenratorBloc({
    required this.generatePasswordUseCase,
    required this.deletePasswordHistoryUseCase,
    required this.getPasswordHistoryUseCase,
    required this.savePasswordUseCase,
  }) : super(PasswordGenratorState.initial()) {
    on<ChangePasswordLengthEvent>(
        (ChangePasswordLengthEvent event, Emitter<PasswordGenratorState> emit) {
      emit(state.copyWith(passwordLength: event.passwordLength));
    });
    on<ChangeLowercaseEvent>(
        (ChangeLowercaseEvent event, Emitter<PasswordGenratorState> emit) {
      if (!state.isLowercase ||
          state.isLowercase && state.isUppercase ||
          state.isLowercase && state.isNumbers ||
          state.isLowercase && state.isSymbols) {
        emit(state.copyWith(isLowercase: !state.isLowercase));
      }
    });
    on<ChangeUppercaseEvent>(
        (ChangeUppercaseEvent event, Emitter<PasswordGenratorState> emit) {
      if (!state.isUppercase ||
          state.isUppercase && state.isLowercase ||
          state.isUppercase && state.isNumbers ||
          state.isUppercase && state.isSymbols) {
        emit(state.copyWith(isUppercase: !state.isUppercase));
      }
    });
    on<ChangeNumbersEvnet>(
        (ChangeNumbersEvnet event, Emitter<PasswordGenratorState> emit) {
      if (!state.isNumbers ||
          state.isNumbers && state.isLowercase ||
          state.isNumbers && state.isUppercase ||
          state.isNumbers && state.isSymbols) {
        emit(state.copyWith(isNumbers: !state.isNumbers));
      }
    });
    on<ChangeSymbolsEvent>(
        (ChangeSymbolsEvent event, Emitter<PasswordGenratorState> emit) {
      if (!state.isSymbols ||
          state.isSymbols && state.isLowercase ||
          state.isSymbols && state.isUppercase ||
          state.isSymbols && state.isNumbers) {
        emit(state.copyWith(isSymbols: !state.isSymbols));
      }
    });
    on<ChangeExcludeDuplicateEvent>((
      ChangeExcludeDuplicateEvent event,
      Emitter<PasswordGenratorState> emit,
    ) {
      emit(state.copyWith(isExcludeDuplicate: !state.isExcludeDuplicate));
    });
    on<ChangeIncludeSpacesEvent>(
        (ChangeIncludeSpacesEvent event, Emitter<PasswordGenratorState> emit) {
      emit(state.copyWith(isIncludeSpaces: !state.isIncludeSpaces));
    });
    on<ChangeEvent>((ChangeEvent event, Emitter<PasswordGenratorState> emit) {
      final int max = getMaxPasswordLength(state);
      emit(
        state.copyWith(
          passwordLength:
              state.passwordLength > max ? max : state.passwordLength,
          maxPasswordLength: max,
        ),
      );
    });
    on<GeneratePasswordSubmittedEvent>((
      GeneratePasswordSubmittedEvent event,
      Emitter<PasswordGenratorState> emit,
    ) {
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
      emit(state.copyWith(password: randomPassword));
    });

    on<SavePasswordEvent>((
      SavePasswordEvent event,
      Emitter<PasswordGenratorState> emit,
    ) {
      savePasswordUseCase.call(
        Password(
          date: DateTime.now(),
          password: state.passwordController.text,
        ),
      );
    });

    on<GetPasswordHistoryEvent>((
      GetPasswordHistoryEvent event,
      Emitter<PasswordGenratorState> emit,
    ) {
      final List<Password> passwordHistory =
          getPasswordHistoryUseCase.call(null);
      emit(state.copyWith(passwordHistory: passwordHistory));
    });

    on<DeletePasswordHistoryEvent>((
      DeletePasswordHistoryEvent event,
      Emitter<PasswordGenratorState> emit,
    ) {
      deletePasswordHistoryUseCase.call(null);

      emit(state.copyWith(passwordHistory: <Password>[]));
    });
  }
  final GeneratePasswordUseCase generatePasswordUseCase;
  final DeletePasswordHistoryUseCase deletePasswordHistoryUseCase;
  final GetPasswordHistoryUseCase getPasswordHistoryUseCase;
  final SavePasswordUseCase savePasswordUseCase;
}

int getMaxPasswordLength(PasswordGenratorState state) {
  int maxPasswordLength = 0;
  if (state.isLowercase) {
    maxPasswordLength += 12;
  }
  if (state.isUppercase) {
    maxPasswordLength += 12;
  }
  if (state.isNumbers) {
    maxPasswordLength += 10;
  }
  if (state.isSymbols) {
    maxPasswordLength += 12;
  }
  if (state.isIncludeSpaces) {
    maxPasswordLength += 2;
  }
  return maxPasswordLength;
}
