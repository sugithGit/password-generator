import '../../../../core/use_case/use_case.dart';
import '../entities/password.dart';
import '../entities/password_settings.dart';
import '../repositories/password_repo.dart';

class GetPasswordHistoryUseCase
    implements UseCase<void, List<PasswordSettings>> {
  GetPasswordHistoryUseCase(this.passwordRepo);
  final PasswordRepo passwordRepo;
  @override
  List<Password> call(void params) {
    return passwordRepo.getPasswordHistory();
  }
}
