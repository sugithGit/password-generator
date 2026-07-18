import '../../../../core/use_case/use_case.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repo.dart';

class SignInWithGoogleUseCase implements UseCase<Future<AuthUser>, void> {
  SignInWithGoogleUseCase(this.authRepo);
  final AuthRepo authRepo;

  @override
  Future<AuthUser> call(void params) {
    return authRepo.signInWithGoogle();
  }
}
