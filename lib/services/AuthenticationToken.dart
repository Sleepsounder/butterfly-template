/// Enumerates various authentication failure reasons.
enum AuthenticationFailureReason {
  invalidCredentials
}

/// Describes an error encountered during the authentication process.
class AuthenticationError {
  /// A failure reason.
  final AuthenticationFailureReason reason;

  final dynamic developerError;

  AuthenticationError({this.reason, this.developerError});
}

/// Describes an authentication token.
class AuthenticationToken {
  /// An identity token.
  final String idToken;

  /// Validity lifetime of the `idToken`, in seconds.
  final int lifetime;

  AuthenticationToken(this.idToken, this.lifetime);
}
