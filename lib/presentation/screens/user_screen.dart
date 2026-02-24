import 'package:flutter/material.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';
import '../controllers/user_controller.dart';

class UserScreen extends StatefulWidget {
  final UserController controller;

  const UserScreen({super.key, required this.controller});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Extracted to a method so we can call it again on "Retry"
  void _loadData() {
    setState(() {
      futureUsers = widget.controller.fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          // Senior Tip: Always provide a manual refresh option
          IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _mapError(snapshot.error),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          }

          final users = snapshot.data ?? [];
          if (users.isEmpty) return const Center(child: Text("No users found."));

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(child: Text(users[index].name[0])),
                title: Text(users[index].name),
                subtitle: Text(users[index].email),
              );
            },
          );
        },
      ),
    );
  }

  String _mapError(Object? error) {
    // 1. Handle No Internet
    if (error is NetworkException) {
      return error.message;
    }

    // 2. Handle 401 (Unauthorized)
    if (error is UnauthorizedException) {
      return error.message;
    }

    // 3. Handle 404, 500, etc. (Drill into the status code)
    if (error is ServerException) {
      switch (error.statusCode) {
        case 404:
          return "Requested data not found (Error 404).";
        case 500:
          return "The server is down. Please try again later (Error 500).";
        case 503:
          return "Service unavailable. The server is under maintenance.";
        default:
          return "Server Error: ${error.statusCode}";
      }
    }

    // 4. Handle Timeouts
    if (error is TimeoutApiException) {
      return "The connection timed out. Check your speed.";
    }

    // 5. Catch-all for everything else
    return "Unexpected error: ${error.toString()}";
  }
}