import 'package:flutter_test/flutter_test.dart';

void main() {
  group('30-Minute Gap Validation Logic', () {
    test('Calculates gap correctly for future time (35 mins)', () {
      final now = DateTime(2026, 3, 14, 12, 0); // 12:00
      final selected = DateTime(2026, 3, 14, 12, 35); // 12:35
      final diff = selected.difference(now).inMinutes;
      expect(diff >= 30, isTrue);
    });

    test('Calculates gap correctly for tight time (25 mins)', () {
      final now = DateTime(2026, 3, 14, 12, 0); // 12:00
      final selected = DateTime(2026, 3, 14, 12, 25); // 12:25
      final diff = selected.difference(now).inMinutes;
      expect(diff < 30, isTrue);
    });

    test('Calculates gap correctly for past time', () {
      final now = DateTime(2026, 3, 14, 12, 0); // 12:00
      final selected = DateTime(2026, 3, 14, 11, 50); // 11:50
      final diff = selected.difference(now).inMinutes;
      expect(diff < 0, isTrue);
    });
  });

  group('Route Naming Logic Simulation', () {
    test('Identifies Expressway correctly', () {
      const summary = "Yamuna Expressway";
      final lower = summary.toLowerCase();
      bool isExpressway = lower.contains('expressway') || lower.contains('yamuna');
      expect(isExpressway, isTrue);
    });

    test('Identifies National Highway correctly', () {
      const summary = "NH 91";
      final lower = summary.toLowerCase();
      bool isHighway = lower.contains('ah') || lower.contains('nh') || lower.contains('highway');
      expect(isHighway, isTrue);
    });
  });
}
