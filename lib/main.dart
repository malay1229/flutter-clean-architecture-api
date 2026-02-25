import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_service.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/usecases/get_user_by_id.dart';
import 'domain/usecases/get_users.dart';
import 'presentation/controllers/user_controller.dart';
import 'presentation/screens/user_list_screen.dart';

void main() {
  final apiService = ApiService(http.Client());
  final repository = UserRepositoryImpl(apiService);
  final getUsers = GetUsers(repository);
  final getUserById = GetUserById(repository);

  Get.put(UserController(getUsers, getUserById));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserListScreen(),
    );
  }
}