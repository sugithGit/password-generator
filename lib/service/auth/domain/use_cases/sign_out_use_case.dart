import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repo.dart';

class SignOutUseCase implements UseCase<Future<void>, void> {
  SignOutUseCase(this.authRepo);
  final AuthRepo authRepo;

  @override
  Future<void> call(void params) {
    return authRepo.signOut();
  }
}
