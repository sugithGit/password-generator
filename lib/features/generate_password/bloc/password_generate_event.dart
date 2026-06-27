part of 'password_generate_bloc.dart';

abstract class PasswordGenratorEvent {}

class ChangeEvent extends PasswordGenratorEvent {}

class ChangePasswordLengthEvent extends ChangeEvent {
  ChangePasswordLengthEvent({required this.passwordLength});
  final int passwordLength;
}

class ChangeLowercaseEvent extends ChangeEvent {}

class ChangeUppercaseEvent extends ChangeEvent {}

class ChangeNumbersEvnet extends ChangeEvent {}

class ChangeSymbolsEvent extends ChangeEvent {}

class ChangeExcludeDuplicateEvent extends ChangeEvent {}

class ChangeIncludeSpacesEvent extends ChangeEvent {}

class GeneratePasswordSubmittedEvent extends PasswordGenratorEvent {}

class SavePasswordEvent extends PasswordGenratorEvent {
  SavePasswordEvent({required this.password});
  final String password;
}

class DeletePasswordHistoryEvent extends PasswordGenratorEvent {}

class GetPasswordHistoryEvent extends PasswordGenratorEvent {}
