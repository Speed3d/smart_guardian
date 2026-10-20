import 'package:flutter_test/flutter_test.dart';
import 'package:parent_app/main.dart';

void main() {
  testWidgets('SmartGuardianParentApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartGuardianParentApp());
    expect(find.text('لوحة تحكم الأب - Smart Guardian'), findsOneWidget);
  });
}
