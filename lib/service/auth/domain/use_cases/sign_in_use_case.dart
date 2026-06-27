import '../../../../core/use_case/use_case.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repo.dart';

class SignInParams {
  const SignInParams({required this.email, required this.password});
  final String email;
  final String password;
}

class SignInUseCase implements UseCase<Future<AuthUser>, SignInParams> {
  SignInUseCase(this.authRepo);
  final AuthRepo authRepo;

  @override
  Future<AuthUser> call(SignInParams params) {
    return authRepo.signIn(email: params.email, password: params.password);
  }
}
