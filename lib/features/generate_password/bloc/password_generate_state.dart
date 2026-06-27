part of 'password_generate_bloc.dart';

class PasswordGenratorState {
  PasswordGenratorState({
    required this.passwordLength,
    required this.maxPasswordLength,
    required this.isLowercase,
    required this.isUppercase,
    required this.isNumbers,
    required this.isSymbols,
    required this.isExcludeDuplicate,
    required this.isIncludeSpaces,
    required this.passwordController,
    this.passwordHistory = const <Password>[],
  });

  factory PasswordGenratorState.initial() => PasswordGenratorState(
        passwordLength: 10,
        maxPasswordLength: 26,
        isLowercase: true,
        isUppercase: false,
        isNumbers: false,
        isSymbols: false,
        isExcludeDuplicate: false,
        isIncludeSpaces: false,
        passwordController: TextEditingController(
          text: "",
        ),
      );
  final int passwordLength;
  final int maxPasswordLength;
  final bool isLowercase;
  final bool isUppercase;
  final bool isNumbers;
  final bool isSymbols;
  final bool isExcludeDuplicate;
  final bool isIncludeSpaces;
  final TextEditingController passwordController;
  final List<Password> passwordHistory;

  PasswordGenratorState copyWith({
    int? passwordLength,
    int? maxPasswordLength,
    bool? isLowercase,
    bool? isUppercase,
    bool? isNumbers,
    bool? isSymbols,
    bool? isExcludeDuplicate,
    bool? isIncludeSpaces,
    String? password,
    List<Password>? passwordHistory,
  }) =>
      PasswordGenratorState(
        passwordLength: passwordLength ?? this.passwordLength,
        maxPasswordLength: maxPasswordLength ?? this.maxPasswordLength,
        isLowercase: isLowercase ?? this.isLowercase,
        isUppercase: isUppercase ?? this.isUppercase,
        isNumbers: isNumbers ?? this.isNumbers,
        isSymbols: isSymbols ?? this.isSymbols,
        isExcludeDuplicate: isExcludeDuplicate ?? this.isExcludeDuplicate,
        isIncludeSpaces: isIncludeSpaces ?? this.isIncludeSpaces,
        passwordController: password != null
            ? TextEditingController(text: password)
            : passwordController,
        passwordHistory: passwordHistory ?? this.passwordHistory,
      );
}
