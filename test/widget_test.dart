import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:malay_api_demo/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Users screen renders AppBar title', (WidgetTester tester) async {
    Get.testMode = true;
    // Clear any previous GetX instances (important for tests)
    Get.reset();

    // Pump the app exactly how production runs it
    await tester.pumpWidget(const MyApp());

    // Allow first frame to build
    await tester.pump();

    // Verify AppBar title exists
    expect(find.text('Users'), findsOneWidget);
  });
}