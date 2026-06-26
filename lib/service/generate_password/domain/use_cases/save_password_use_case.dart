import '../../../../core/use_case/use_case.dart';
import '../entities/password.dart';
import '../repositories/password_repo.dart';

class SavePasswordUseCase implements UseCase<void, Password> {
  SavePasswordUseCase(this.passwordRepo);
  final PasswordRepo passwordRepo;

  @override
  void call(Password params) {
    return passwordRepo.savePassword(params);
  }
}
