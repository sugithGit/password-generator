import 'dart:math';

import '../../domain/entities/password_settings.dart';

class PasswordGenerator {
  final Map<String, String> _characters = <String, String>{
    'lowercase': 'abcdefghijklmnopqrstuvwxyz',
    'uppercase': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    'numbers': '0123456789',
    'symbols': r"!$%&|[](){}:;.,*+-#@<>~",
  };

  String generatePassword(PasswordSettings passwordSettings) {
    String staticPassword = "";
    String randomPassword = "";
    if (passwordSettings.withLowercase) {
      staticPassword += _characters['lowercase']!;
    }
    if (passwordSettings.withUppercase) {
      staticPassword += _characters['uppercase']!;
    }
    if (passwordSettings.withNumbers) {
      staticPassword += _characters['numbers']!;
    }
    if (passwordSettings.withSymbols) {
      staticPassword += _characters['symbols']!;
    }
    if (passwordSettings.includeSpaces) {
      staticPassword += ' $staticPassword ';
    }

    for (int i = 0; i < passwordSettings.passwordLength; i++) {
      final String randomChar = staticPassword[
          (Random().nextDouble() * staticPassword.length).floor()];

      if (passwordSettings.excludeDuplicates) {
        !randomPassword.contains(randomChar) || randomChar == " "
            ? randomPassword += randomChar
            : i--;
      } else {
        randomPassword += randomChar;
      }
    }
    return randomPassword;
  }
}
