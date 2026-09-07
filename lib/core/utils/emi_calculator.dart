import 'dart:math';

/// Calculates the monthly EMI using the standard reducing-balance formula.
///
/// Formula: EMI = P × r × (1+r)^n / ((1+r)^n − 1)
///
/// Where:
/// - P = [principal] (loan amount)
/// - r = monthly interest rate = [annualRatePercent] / 12 / 100
/// - n = [tenureMonths]
///
/// If [annualRatePercent] is 0 (no-cost EMI), returns `principal / tenureMonths`.
///
/// Returns the monthly EMI amount, rounded to 2 decimal places.
double calculateMonthlyEmi({
  required double principal,
  required double annualRatePercent,
  required int tenureMonths,
}) {
  assert(principal > 0, 'Principal must be positive');
  assert(tenureMonths > 0, 'Tenure must be at least 1 month');
  assert(annualRatePercent >= 0, 'Interest rate cannot be negative');

  // No-cost EMI — simple division
  if (annualRatePercent == 0) {
    return double.parse((principal / tenureMonths).toStringAsFixed(2));
  }

  final r = annualRatePercent / 12 / 100; // monthly rate
  final n = tenureMonths;
  final rPowN = pow(1 + r, n).toDouble();

  final emi = principal * r * rPowN / (rPowN - 1);
  return double.parse(emi.toStringAsFixed(2));
}

/// Returns the total amount payable over the full tenure.
double calculateTotalAmount({
  required double monthlyEmi,
  required int tenureMonths,
}) {
  return double.parse((monthlyEmi * tenureMonths).toStringAsFixed(2));
}

/// Returns the total interest component.
double calculateTotalInterest({
  required double principal,
  required double monthlyEmi,
  required int tenureMonths,
}) {
  final total = monthlyEmi * tenureMonths;
  return double.parse((total - principal).toStringAsFixed(2));
}
