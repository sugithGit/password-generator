import '../../../../core/use_case/use_case.dart';
import '../repositories/biometric_repo.dart';

class CanCheckBiometricsUseCase implements UseCase<Future<bool>, void> {
  CanCheckBiometricsUseCase(this.biometricRepo);
  final BiometricRepo biometricRepo;

  @override
  Future<bool> call(void params) {
    return biometricRepo.canCheckBiometrics();
  }
}
