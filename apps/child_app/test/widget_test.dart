import 'package:flutter_test/flutter_test.dart';
import 'package:child_app/core/di/service_locator.dart';
import 'package:child_app/main.dart';
import 'fakes/fake_command_data_source.dart';

void main() {
  setUpAll(() async {
    await initChildServiceLocator(
      mockCommandDataSource: FakeCommandDataSource(),
      mockPairingDataSource: FakePairingDataSource(),
      mockUsageDataSource: FakeUsageDataSource(),
    );
  });

  testWidgets('SmartGuardianChildApp shows PairingScreen when not paired',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SmartGuardianChildApp(initialIsPaired: false));
    await tester.pumpAndSettle();
    expect(find.text('ربط جهاز الطفل'), findsOneWidget);
    expect(find.text('أدخل رمز الربط الرقمي'), findsOneWidget);
  });

  testWidgets('SmartGuardianChildApp shows ChildStatusScreen when paired',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SmartGuardianChildApp(initialIsPaired: true));
    await tester.pumpAndSettle();
    expect(find.text('Smart Guardian - وضع الحماية'), findsOneWidget);
    expect(find.text('الحماية الذكية مفعلة'), findsOneWidget);
    expect(find.text('طلب مساعدة طارئة (SOS)'), findsOneWidget);
  });
}
