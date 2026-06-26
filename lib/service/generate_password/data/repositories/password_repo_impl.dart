import '../../domain/entities/password.dart';
import '../../domain/entities/password_settings.dart';
import '../../domain/repositories/password_repo.dart';
import '../local/password_gnerator.dart';
import '../local/save_password.dart';
import '../model/password_model.dart';

class PasswordRepoImpl implements PasswordRepo {
  PasswordRepoImpl({
    required this.passwordGenerator,
    required this.passwordHistoryLocal,
  });
  PasswordGenerator passwordGenerator;
  PasswordHistoryLocal passwordHistoryLocal;

  @override
  String generatePassword(PasswordSettings passwordSettings) {
    return passwordGenerator.generatePassword(passwordSettings);
  }

  @override
  void savePassword(Password password) {
    return passwordHistoryLocal.savePassword(
      password: PasswordModel.fromPassword(password: password),
    );
  }

  @override
  void deletePasswordHistory() {
    return passwordHistoryLocal.deletePassword();
  }

  @override
  List<Password> getPasswordHistory() {
    return passwordHistoryLocal
        .getPasswordHistory()
        .map((PasswordModel e) => e.toPassword())
        .toList();
  }
}
