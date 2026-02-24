// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:malay_api_demo/core/network/api_service.dart';
import 'package:malay_api_demo/data/repositories/user_repository_impl.dart';
import 'package:malay_api_demo/domain/usecases/get_users.dart';

import 'package:malay_api_demo/main.dart';
import 'package:malay_api_demo/presentation/controllers/user_controller.dart';

void main() {
  testWidgets('API Demo Screen Test', (WidgetTester tester) async {
    // For now, we use the real objects, but this requires internet to pass
    final apiService = ApiService(http.Client());
    final repository = UserRepositoryImpl(apiService);
    final getUsers = GetUsers(repository);
    final controller = UserController(getUsers);

    // FIXED CALL: Added the 'controller:' label
    await tester.pumpWidget(
      MyApp(controller: controller),
    );

    // Remove the counter expectations! They will fail.
    // Instead, check if the AppBar title is correct
    expect(find.text('Users'), findsOneWidget);
  });
}
