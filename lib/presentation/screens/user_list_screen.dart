import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatelessWidget {
  final UserController controller = Get.find();

  UserListScreen({super.key}) {
    controller.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                ElevatedButton(
                  onPressed: controller.fetchUsers,
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];

            return Card(
              child: ListTile(
                title: Text(user.name),
                subtitle: Text("${user.email}\n${user.phone}"),
                isThreeLine: true,
                onTap: () {
                  Get.to(() => UserDetailScreen(userId: user.id));
                },
              ),
            );
          },
        );
      }),
    );
  }
}