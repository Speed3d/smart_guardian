import 'package:sg_core/sg_core.dart';
import 'package:test/test.dart';

void main() {
  group('AppDateUtils Tests', () {
    test('formatDurationMinutes formats hours and minutes properly in Arabic', () {
      expect(AppDateUtils.formatDurationMinutes(75), '1 ساعة و 15 دقيقة');
      expect(AppDateUtils.formatDurationMinutes(60), '1 ساعة');
      expect(AppDateUtils.formatDurationMinutes(45), '45 دقيقة');
      expect(AppDateUtils.formatDurationMinutes(0), 'انتهى الوقت');
    });
  });
}
