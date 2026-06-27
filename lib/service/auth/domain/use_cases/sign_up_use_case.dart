import '../../../../core/use_case/use_case.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repo.dart';

class SignUpParams {
  const SignUpParams({required this.email, required this.password});
  final String email;
  final String password;
}

class SignUpUseCase implements UseCase<Future<AuthUser>, SignUpParams> {
  SignUpUseCase(this.authRepo);
  final AuthRepo authRepo;

  @override
  Future<AuthUser> call(SignUpParams params) {
    return authRepo.signUp(email: params.email, password: params.password);
  }
}
