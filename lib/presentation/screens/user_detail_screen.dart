import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late final UserController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<UserController>();

    // Clear stale data from previous navigation before fetching new user
    controller.clearSelectedUser();

    // Safe: runs once, after widget is in the tree
    controller.fetchUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Detail")),
      body: Stack(
        children: [
          // User detail content — only rebuilds when selectedUser changes
          Obx(() {
            final user = controller.selectedUser.value;

            if (user == null) return const SizedBox.shrink();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailTile(
                    icon: Icons.person,
                    label: "Name",
                    value: user.name,
                  ),
                  _DetailTile(
                    icon: Icons.alternate_email,
                    label: "Username",
                    value: user.username,
                  ),
                  _DetailTile(
                    icon: Icons.email_outlined,
                    label: "Email",
                    value: user.email,
                  ),
                  _DetailTile(
                    icon: Icons.phone_outlined,
                    label: "Phone",
                    value: user.phone,
                  ),
                  _DetailTile(
                    icon: Icons.language,
                    label: "Website",
                    value: user.website,
                  ),
                  _DetailTile(
                    icon: Icons.business,
                    label: "Company",
                    value: user.companyName,
                  ),
                  _DetailTile(
                    icon: Icons.location_on_outlined,
                    label: "Address",
                    value: user.address,
                  ),
                ],
              ),
            );
          }),

          // Loading overlay — only rebuilds when isUserDetailLoading changes
          Obx(() {
            if (!controller.isUserDetailLoading.value) {
              return const SizedBox.shrink();
            }
            return const ColoredBox(
              color: Colors.black12,
              child: Center(child: CircularProgressIndicator()),
            );
          }),

          // Error layer — only rebuilds when userDetailError changes
          Obx(() {
            if (controller.userDetailError.isEmpty) {
              return const SizedBox.shrink();
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      controller.userDetailError.value,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => controller.fetchUserById(widget.userId),
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

// Extracted reusable detail row widget
class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(value, style: textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}