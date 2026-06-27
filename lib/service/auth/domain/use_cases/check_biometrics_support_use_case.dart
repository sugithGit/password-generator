import '../../../../core/use_case/use_case.dart';
import '../repositories/biometric_repo.dart';

class CheckBiometricsSupportUseCase implements UseCase<Future<bool>, void> {
  CheckBiometricsSupportUseCase(this.biometricRepo);
  final BiometricRepo biometricRepo;

  @override
  Future<bool> call(void params) {
    return biometricRepo.isDeviceSupported();
  }
}
