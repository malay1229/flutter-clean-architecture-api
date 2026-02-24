import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Required for http.Client()

// Core
import 'core/network/api_service.dart';

// Data
import 'data/repositories/user_repository_impl.dart';

// Domain
import 'domain/usecases/get_users.dart';

// Presentation
import 'presentation/controllers/user_controller.dart';
import 'presentation/screens/user_screen.dart';

void main() {
  // 1. Initialize the HTTP Client
  final httpClient = http.Client();

  // 2. Setup Dependency Injection
  final apiService = ApiService(httpClient);
  final repository = UserRepositoryImpl(apiService);
  final getUsersUseCase = GetUsers(repository);
  final controller = UserController(getUsersUseCase);

  runApp(MyApp(controller: controller));
}

class MyApp extends StatelessWidget {
  final UserController controller;

  const MyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Error Handling Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserScreen(controller: controller),
      debugShowCheckedModeBanner: false,
    );
  }
}