class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}

class TokenExpiredException extends AuthException {
  TokenExpiredException(super.message);
}
