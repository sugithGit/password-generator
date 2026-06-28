abstract class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthPermissionDeniedException extends AuthException {
  const AuthPermissionDeniedException([
    super.message = 'Session expired or user deleted. Please log in again.',
  ]);
}

class AuthInvalidCredentialsException extends AuthException {
  const AuthInvalidCredentialsException([
    super.message = 'Invalid email or password.',
  ]);
}

class AuthUserNotFoundException extends AuthException {
  const AuthUserNotFoundException([
    super.message = 'No user found with this email.',
  ]);
}

class AuthWrongPasswordException extends AuthException {
  const AuthWrongPasswordException([super.message = 'Incorrect password.']);
}

class AuthEmailAlreadyInUseException extends AuthException {
  const AuthEmailAlreadyInUseException([
    super.message = 'An account already exists with this email.',
  ]);
}

class AuthWeakPasswordException extends AuthException {
  const AuthWeakPasswordException([super.message = 'Password is too weak.']);
}

class AuthInvalidEmailException extends AuthException {
  const AuthInvalidEmailException([super.message = 'Invalid email address.']);
}

class AuthUnknownException extends AuthException {
  const AuthUnknownException([
    super.message = 'Authentication failed. Please try again.',
  ]);
}
