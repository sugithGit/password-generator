import '../../../../core/use_case/use_case.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repo.dart';

class GetCurrentUserUseCase implements UseCase<AuthUser?, void> {
  GetCurrentUserUseCase(this.authRepo);
  final AuthRepo authRepo;

  @override
  AuthUser? call(void params) {
    return authRepo.currentUser;
  }
}
