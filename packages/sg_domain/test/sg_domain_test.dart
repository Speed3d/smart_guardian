import 'package:sg_domain/sg_domain.dart';
import 'package:test/test.dart';

void main() {
  group('ChildEntity Tests', () {
    test('Calculates remaining minutes and exhaustion correctly', () {
      final child = ChildEntity(
        id: 'child_1',
        parentId: 'parent_1',
        name: 'أحمد',
        age: 10,
        dailyScreenTimeLimitMinutes: 120,
        usedScreenTimeTodayMinutes: 80,
        isLocked: false,
        lastActiveAt: DateTime.now(),
      );

      expect(child.remainingMinutes, 40);
      expect(child.hasExhaustedTime, false);
    });
  });
}
