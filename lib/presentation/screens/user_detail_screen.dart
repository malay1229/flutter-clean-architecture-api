import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class UserDetailScreen extends StatelessWidget {
  final int userId;

  UserDetailScreen({super.key, required this.userId});

  final UserController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.fetchUserById(userId);

    return Scaffold(
      appBar: AppBar(title: const Text("User Detail")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(controller.errorMessage.value),
          );
        }

        final user = controller.selectedUser.value;

        if (user == null) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${user.name}"),
              Text("Username: ${user.username}"),
              Text("Email: ${user.email}"),
              Text("Phone: ${user.phone}"),
              Text("Website: ${user.website}"),
              Text("Company: ${user.companyName}"),
              Text("Address: ${user.address}"),
            ],
          ),
        );
      }),
    );
  }
}