// Every exception carries its own user-friendly message.
// Screens NEVER define error messages. They come from here.

class NoInternetException implements Exception {
  final String message = "No internet connection. Please check your network.";
}

class TimeoutException implements Exception {
  final String message = "The request timed out. Please try again.";
}

class BadRequestException implements Exception {
  final String message = "Something went wrong with the request.";
}

class UnauthorizedException implements Exception {
  final String message = "You are not authorized.";
}

class ForbiddenException implements Exception {
  final String message = "Access denied.";
}

class NotFoundException implements Exception {
  final String message = "The requested data could not be found.";
}

class ServerException implements Exception {
  final String message = "Server error. Please try later.";
}

class ServiceUnavailableException implements Exception {
  final String message = "Service is currently unavailable.";
}

class UnexpectedStatusException implements Exception {
  final int statusCode;
  UnexpectedStatusException(this.statusCode);

  String get message => "Unexpected error occurred (code: $statusCode)";
}

class InvalidResponseException implements Exception {
  final String message = "Received invalid data from server.";
}

class UnknownException implements Exception {
  final String message = "An unexpected error occurred.";
}