import '../../../../core/use_case/use_case.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repo.dart';

class GetAuthStateChangesUseCase implements UseCase<Stream<AuthUser?>, void> {
  GetAuthStateChangesUseCase(this.authRepo);
  final AuthRepo authRepo;

  @override
  Stream<AuthUser?> call(void params) {
    return authRepo.authStateChanges;
  }
}
