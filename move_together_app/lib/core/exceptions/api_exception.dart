class ApiException extends Error {
  final String message;

  ApiException({required this.message});
}