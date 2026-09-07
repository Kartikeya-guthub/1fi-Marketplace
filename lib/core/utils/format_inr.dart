/// Formats [amount] as Indian Rupees with the Indian numbering system.
///
/// Examples:
/// ```
/// formatINR(1234)      → '₹1,234'
/// formatINR(123456)    → '₹1,23,456'
/// formatINR(10000000)  → '₹1,00,00,000'
/// formatINR(999.5)     → '₹1,000'   (rounds to nearest int)
/// ```
String formatINR(double amount) {
  final rounded = amount.round();
  if (rounded < 0) return '-${formatINR(-amount)}';

  final str = rounded.toString();
  final len = str.length;

  if (len <= 3) return '₹$str';

  // First group of 3 from the right, then groups of 2.
  final buffer = StringBuffer();
  // Last 3 digits
  final lastThree = str.substring(len - 3);
  final remaining = str.substring(0, len - 3);

  // Insert commas every 2 digits in the remaining portion
  final remLen = remaining.length;
  for (var i = 0; i < remLen; i++) {
    if (i > 0 && (remLen - i) % 2 == 0) {
      buffer.write(',');
    }
    buffer.write(remaining[i]);
  }

  return '₹${buffer.toString()},$lastThree';
}

/// Formats [amount] as a compact INR string for display in badges/pills.
///
/// Examples:
/// ```
/// formatINRCompact(999)     → '₹999'
/// formatINRCompact(1500)    → '₹1.5K'
/// formatINRCompact(150000)  → '₹1.5L'
/// formatINRCompact(1500000) → '₹15L'
/// formatINRCompact(15000000)→ '₹1.5Cr'
/// ```
String formatINRCompact(double amount) {
  if (amount < 1000) return '₹${amount.round()}';
  if (amount < 100000) {
    final k = amount / 1000;
    return k == k.roundToDouble()
        ? '₹${k.round()}K'
        : '₹${k.toStringAsFixed(1)}K';
  }
  if (amount < 10000000) {
    final l = amount / 100000;
    return l == l.roundToDouble()
        ? '₹${l.round()}L'
        : '₹${l.toStringAsFixed(1)}L';
  }
  final cr = amount / 10000000;
  return cr == cr.roundToDouble()
      ? '₹${cr.round()}Cr'
      : '₹${cr.toStringAsFixed(1)}Cr';
}
