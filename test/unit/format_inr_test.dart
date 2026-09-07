import 'package:flutter_test/flutter_test.dart';
import 'package:onefi_marketplace/core/utils/format_inr.dart';

void main() {
  group('formatINR', () {
    test('formats hundreds correctly without commas', () {
      expect(formatINR(999), '₹999');
    });

    test('formats thousands with correct comma placement', () {
      expect(formatINR(1234), '₹1,234');
      expect(formatINR(12345), '₹12,345');
    });

    test('formats lakhs with Indian comma system (2, 2, 3)', () {
      expect(formatINR(123456), '₹1,23,456');
      expect(formatINR(9876543), '₹98,76,543');
    });

    test('formats crores with Indian comma system', () {
      expect(formatINR(12345678), '₹1,23,45,678');
    });

    test('rounds decimals to nearest integer', () {
      expect(formatINR(999.4), '₹999');
      expect(formatINR(999.5), '₹1,000');
    });
  });

  group('formatINRCompact', () {
    test('formats values under 1K', () {
      expect(formatINRCompact(999), '₹999');
    });

    test('formats values in K', () {
      expect(formatINRCompact(1500), '₹1.5K');
      expect(formatINRCompact(10000), '₹10K');
    });

    test('formats values in Lakhs', () {
      expect(formatINRCompact(150000), '₹1.5L');
      expect(formatINRCompact(1000000), '₹10L');
    });

    test('formats values in Crores', () {
      expect(formatINRCompact(15000000), '₹1.5Cr');
    });
  });
}
