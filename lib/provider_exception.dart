/// Whether to retry.
/// [retry]retry
/// [none]none
enum Retryable { retry, none }

/// Provider exception.
class ProviderException implements Exception {
  final Retryable retryable;
  final String message;
  final int? statusCode;

  ProviderException(
      {required this.message, this.statusCode, required this.retryable});

  @override
  String toString() => message;
}
