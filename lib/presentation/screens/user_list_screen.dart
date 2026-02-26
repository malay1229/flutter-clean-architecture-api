import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  // Safe: Get.find() runs after the widget is registered in the tree
  late final UserController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<UserController>();
    // Correct place for side effects — after widget is inserted into the tree
    controller.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: Stack(
        children: [
          // List only rebuilds when users list changes
          Obx(() {
            if (controller.users.isEmpty &&
                !controller.isUsersLoading.value &&
                controller.usersError.isEmpty) {
              return const Center(child: Text("No users found."));
            }

            return ListView.builder(
              itemCount: controller.users.length,
              itemBuilder: (context, index) {
                final user = controller.users[index];
                return Card(
                  child: ListTile(
                    title: Text(user.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email),
                        Text(user.phone),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () => Get.to(() => UserDetailScreen(userId: user.id)),
                  ),
                );
              },
            );
          }),

          // Loading overlay only rebuilds when isUsersLoading changes
          Obx(() {
            if (!controller.isUsersLoading.value) return const SizedBox.shrink();
            return const ColoredBox(
              color: Colors.black12,
              child: Center(child: CircularProgressIndicator()),
            );
          }),

          // Error layer only rebuilds when usersError changes
          Obx(() {
            if (controller.usersError.isEmpty) return const SizedBox.shrink();
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      controller.usersError.value,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: controller.fetchUsers,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}