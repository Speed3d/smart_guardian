import 'package:flutter_test/flutter_test.dart';
import 'package:parent_app/core/di/service_locator.dart';
import 'package:parent_app/main.dart';
import 'fakes/fake_data_sources.dart';

void main() {
  setUpAll(() async {
    await initServiceLocator(
      mockAuthDataSource: FakeAuthDataSource(),
      mockChildDataSource: FakeChildDataSource(),
      mockCommandDataSource: FakeCommandDataSource(),
      mockPairingDataSource: FakePairingDataSource(),
    );
  });

  testWidgets('SmartGuardianParentApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartGuardianParentApp());
    await tester.pumpAndSettle();
    expect(find.text('لوحة تحكم الأب - Smart Guardian'), findsOneWidget);
    expect(find.text('جهاز: أحمد'), findsOneWidget);
    expect(find.text('توليد رمز ربط جهاز الطفل (Pairing Code)'), findsOneWidget);
  });
}
