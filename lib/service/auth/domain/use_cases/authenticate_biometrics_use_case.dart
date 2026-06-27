import '../../../../core/use_case/use_case.dart';
import '../repositories/biometric_repo.dart';

class AuthenticateBiometricsUseCase implements UseCase<Future<bool>, String> {
  AuthenticateBiometricsUseCase(this.biometricRepo);
  final BiometricRepo biometricRepo;

  @override
  Future<bool> call(String params) {
    return biometricRepo.authenticate(reason: params);
  }
}
