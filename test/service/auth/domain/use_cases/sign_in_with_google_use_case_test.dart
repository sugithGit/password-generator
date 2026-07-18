import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:password_generator/service/auth/domain/entities/auth_user.dart';
import 'package:password_generator/service/auth/domain/repositories/auth_repo.dart';
import 'package:password_generator/service/auth/domain/use_cases/sign_in_with_google_use_case.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockAuthRepo;
  late SignInWithGoogleUseCase useCase;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    useCase = SignInWithGoogleUseCase(mockAuthRepo);
  });

  const testUser = AuthUser(uid: '123', email: 'test@example.com');

  test(
    'should call signInWithGoogle on AuthRepo and return AuthUser',
    () async {
      // Arrange
      when(
        () => mockAuthRepo.signInWithGoogle(),
      ).thenAnswer((_) async => testUser);

      // Act
      final result = await useCase.call(null);

      // Assert
      expect(result, testUser);
      verify(() => mockAuthRepo.signInWithGoogle()).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    },
  );
}
