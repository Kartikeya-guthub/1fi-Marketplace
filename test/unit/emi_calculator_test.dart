import 'package:flutter_test/flutter_test.dart';
import 'package:onefi_marketplace/core/utils/emi_calculator.dart';

void main() {
  group('calculateMonthlyEmi', () {
    test('calculates correct EMI for standard interest rate', () {
      // 1 Lakh at 10% p.a. for 12 months
      final emi = calculateMonthlyEmi(
        principal: 100000,
        annualRatePercent: 10.0,
        tenureMonths: 12,
      );
      // Expected: ~8791.59
      expect(emi, closeTo(8791.59, 0.01));
    });

    test('calculates correct EMI for no-cost EMI (0% interest)', () {
      // 1.2 Lakhs for 12 months at 0%
      final emi = calculateMonthlyEmi(
        principal: 120000,
        annualRatePercent: 0.0,
        tenureMonths: 12,
      );
      // Expected: 10000.00
      expect(emi, equals(10000.00));
    });

    test('throws assertion error for invalid inputs', () {
      expect(
        () => calculateMonthlyEmi(
          principal: -1000,
          annualRatePercent: 10.0,
          tenureMonths: 12,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => calculateMonthlyEmi(
          principal: 100000,
          annualRatePercent: 10.0,
          tenureMonths: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('calculateTotalAmount & calculateTotalInterest', () {
    test('calculates correct totals', () {
      const emi = 8791.59;
      const tenure = 12;
      const principal = 100000.0;

      final total = calculateTotalAmount(monthlyEmi: emi, tenureMonths: tenure);
      expect(total, closeTo(105499.08, 0.01));

      final interest = calculateTotalInterest(
        principal: principal,
        monthlyEmi: emi,
        tenureMonths: tenure,
      );
      expect(interest, closeTo(5499.08, 0.01));
    });
  });
}
