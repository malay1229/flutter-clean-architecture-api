import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../error/exceptions.dart';

class ApiService {
  final http.Client client; // Injected HTTP client

  ApiService(this.client);

  Future<dynamic> get(String url) async {
    // 1️⃣ Check internet connectivity first
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NoInternetException();
    }

    try {
      // 2️⃣ Perform GET with 10 second timeout
      final response = await client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      // 3️⃣ Handle status codes centrally
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on http.ClientException {
      throw NoInternetException();
    } on FormatException {
      throw InvalidResponseException();
    } on Exception {
      throw UnknownException();
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) {
          throw InvalidResponseException();
        }
        return jsonDecode(response.body);

      case 400:
        throw BadRequestException();

      case 401:
        throw UnauthorizedException();

      case 403:
        throw ForbiddenException();

      case 404:
        throw NotFoundException();

      case 408:
        throw TimeoutException();

      case 500:
        throw ServerException();

      case 503:
        throw ServiceUnavailableException();

      default:
        throw UnexpectedStatusException(response.statusCode);
    }
  }
}