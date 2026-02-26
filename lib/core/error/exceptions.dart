// app_exceptions.dart

abstract class AppException implements Exception {
  final String message;
  final String? details;

  AppException(this.message, [this.details]);

  @override
  String toString() => "AppException: $message ${details ?? ''}";
}

class NoInternetException extends AppException {
  NoInternetException([String? details])
      : super("No internet connection. Please check your network.", details);
}

class DeadlineExceededException extends AppException {
  DeadlineExceededException([String? details])
      : super("The request timed out. Please try again.", details);
}

class BadRequestException extends AppException {
  BadRequestException([String? details])
      : super("Something went wrong with the request.", details);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? details])
      : super("You are not authorized. Please log in again.", details);
}

class NotFoundException extends AppException {
  NotFoundException([String? details])
      : super("The requested data could not be found.", details);
}

class ServerException extends AppException {
  ServerException([String? details])
      : super("Server error. Please try again later.", details);
}

class InvalidResponseException extends AppException {
  InvalidResponseException([String? details])
      : super("Received invalid data from the server.", details);
}

class UnexpectedStatusException extends AppException {
  final int statusCode;
  UnexpectedStatusException(this.statusCode, [String? details])
      : super("Unexpected error (Code: $statusCode)", details);
}