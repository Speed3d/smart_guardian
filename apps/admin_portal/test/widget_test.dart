import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:admin_portal/core/di/service_locator.dart';
import 'package:admin_portal/main.dart';
import 'fakes/fake_admin_data_sources.dart';

void main() {
  setUpAll(() async {
    await initAdminServiceLocator(
      mockChildDataSource: FakeAdminChildDataSource(),
      mockCommandDataSource: FakeAdminCommandDataSource(),
      mockPairingDataSource: FakeAdminPairingDataSource(),
      mockUsageDataSource: FakeAdminUsageDataSource(),
    );
  });

  testWidgets('SmartGuardianAdminApp renders admin dashboard, KPIs and navigation tabs',
      (WidgetTester tester) async {
    // تحديد أبعاد شاشة سطح المكتب للويب
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const SmartGuardianAdminApp());
    await tester.pumpAndSettle();

    // التحقق من ظهور الشعار والشريط الجانبي
    expect(find.text('Smart Guardian'), findsOneWidget);
    expect(find.text('لوحة المشرف والدعم الفني'), findsOneWidget);
    expect(find.text('نظرة عامة (Overview)'), findsOneWidget);
    expect(find.text('العوائل والأطفال'), findsOneWidget);
    expect(find.text('الدعم الفني والطوارئ'), findsOneWidget);
    expect(find.text('مراقبة تكلفة Firebase'), findsOneWidget);

    // التحقق من بطاقات المؤشرات الرئيسية
    expect(find.text('إجمالي العوائل'), findsOneWidget);
    expect(find.text('الأطفال بالحماية'), findsOneWidget);

    // الانتقال لتبويب الدعم الفني والطوارئ
    await tester.tap(find.text('الدعم الفني والطوارئ'));
    await tester.pumpAndSettle();

    expect(find.text('مركز التدخل الطارئ والدعم الفني (Support Agent Override)'), findsOneWidget);
    expect(find.text('فك القفل الطارئ للجهاز (Emergency Unlock)'), findsOneWidget);
    expect(find.text('قفل طارئ للجهاز (Emergency Lock)'), findsOneWidget);

    // الانتقال لتبويب مراقبة التكلفة
    await tester.tap(find.text('مراقبة تكلفة Firebase'));
    await tester.pumpAndSettle();

    expect(find.text('تحليل استهلاك الموارد وتكاليف السحابة (Cloud Cost Analysis)'), findsOneWidget);
    expect(find.text('التكلفة الشهرية'), findsOneWidget);
  });
}
