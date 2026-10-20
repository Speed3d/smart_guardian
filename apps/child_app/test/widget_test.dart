import 'package:flutter_test/flutter_test.dart';
import 'package:child_app/core/di/service_locator.dart';
import 'package:child_app/main.dart';
import 'fakes/fake_command_data_source.dart';

void main() {
  setUpAll(() async {
    await initChildServiceLocator(
      mockCommandDataSource: FakeCommandDataSource(),
    );
  });

  testWidgets('SmartGuardianChildApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartGuardianChildApp());
    await tester.pumpAndSettle();
    expect(find.text('Smart Guardian - وضع الحماية'), findsOneWidget);
  });
}
