import 'package:flutter_test/flutter_test.dart';
import 'package:child_app/main.dart';

void main() {
  testWidgets('SmartGuardianChildApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartGuardianChildApp());
    expect(find.text('Smart Guardian - وضع الحماية'), findsOneWidget);
  });
}
