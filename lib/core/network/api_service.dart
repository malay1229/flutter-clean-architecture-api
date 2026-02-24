import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

class ApiService {
  final http.Client client;

  ApiService(this.client);

  Future<List<dynamic>> get(String url) async {
    try {
      final response = await client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      // 1. Handle Successful Responses (200-299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      }

      // 2. Handle Specific Client Errors
      if (response.statusCode == 401) {
        throw UnauthorizedException("Session expired. Please log in again.");
      }

      if (response.statusCode == 404) {
        throw ServerException("Resource not found", 404);
      }

      // 3. Handle Server Errors (500+)
      if (response.statusCode >= 500) {
        throw ServerException("Internal server error", response.statusCode);
      }

      // 4. Fallback for any other status code
      throw ServerException(
        "Unexpected error occurred",
        response.statusCode,
      );

    } on SocketException {
      // This is the specific "No Internet" trigger
      throw NetworkException("No internet connection. Please check your network.");
    } on TimeoutException {
      throw TimeoutApiException("The request timed out. Please try again.");
    } on http.ClientException catch (e) {
      // Catch-all for http-specific failures (like host lookup failures)
      throw NetworkException("Connection failed: ${e.message}");
    } catch (e) {
      // If we land here, it's something we didn't plan for.
      // We pass the actual error string so the UI can display it during debugging.
      debugPrint("ApiService Caught Unknown Error: $e");
      throw UnexpectedException("Error: ${e.toString()}");
    }
  }
}