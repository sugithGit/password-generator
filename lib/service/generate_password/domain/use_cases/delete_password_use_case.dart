import '../../../../core/use_case/use_case.dart';
import '../repositories/password_repo.dart';

class DeletePasswordHistoryUseCase implements UseCase<void, void> {
  DeletePasswordHistoryUseCase(this.passwordRepo);
  final PasswordRepo passwordRepo;

  @override
  void call(void params) {
    return passwordRepo.deletePasswordHistory();
  }
}
