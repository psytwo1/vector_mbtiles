/// Whether to retry.
/// [retry]retry
/// [none]none
enum Retryable { retry, none }

/// Provider exception.
class ProviderException implements Exception {
  ProviderException({
    required this.message,
    this.statusCode,
    required this.retryable,
  });
  final Retryable retryable;
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
