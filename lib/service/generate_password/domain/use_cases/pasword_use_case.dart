import '../../../../core/use_case/use_case.dart';
import '../entities/password_settings.dart';
import '../repositories/password_repo.dart';

class GeneratePasswordUseCase implements UseCase<String, PasswordSettings> {
  GeneratePasswordUseCase(this.passwordRepo);
  final PasswordRepo passwordRepo;

  @override
  String call(PasswordSettings params) {
    return passwordRepo.generatePassword(params);
  }
}
