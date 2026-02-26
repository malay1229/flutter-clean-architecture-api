import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';

abstract class BaseApi {
  dynamic handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) throw InvalidResponseException();
        return jsonDecode(response.body);
      case 400: throw BadRequestException();
      case 401: throw UnauthorizedException();
      case 404: throw NotFoundException();
      case 500: throw ServerException();
      default:
        throw UnexpectedStatusException(response.statusCode);
    }
  }

  Exception mapException(Object e) {
    // If it's already one of our custom exceptions, return it as is
    if (e is AppException) return e;

    if (e is SocketException || e is http.ClientException) {
      return NoInternetException(e.toString());
    } else if (e is TimeoutException) {
      return DeadlineExceededException(e.toString());
    } else if (e is FormatException) {
      return InvalidResponseException(e.toString());
    }
    return InvalidResponseException("Unknown error: ${e.toString()}");
  }
}

class ApiService extends BaseApi {
  final http.Client client;
  ApiService(this.client);

  Future<T> get<T>({
    required String url,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      final decodedData = handleResponse(response);
      return fromJson(decodedData);

    } catch (e, stackTrace) {
      Error.throwWithStackTrace(mapException(e), stackTrace);
    }
  }
}