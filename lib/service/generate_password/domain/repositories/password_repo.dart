import '../entities/password.dart';
import '../entities/password_settings.dart';

abstract interface class PasswordRepo {
  String generatePassword(PasswordSettings passwordSettings);
  void savePassword(Password password);
  List<Password> getPasswordHistory();
  void deletePasswordHistory();
}
