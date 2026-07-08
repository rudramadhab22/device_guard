import 'package:flutter_test/flutter_test.dart';
import 'package:device_guard_example/src/app.dart';

void main() {
  testWidgets('Verify Device Guard App starts', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DeviceGuardApp());

    // Verify that splash screen is shown with correct title.
    expect(find.text('Device Guard'), findsOneWidget);
  });
}
