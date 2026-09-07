import 'package:flutter_riverpod/flutter_riverpod.dart';

// Current selected variant ID
final selectedVariantIdProvider = StateProvider.autoDispose<String?>((ref) => null);

// Current selected EMI Plan ID
final selectedEmiPlanIdProvider = StateProvider.autoDispose<String?>((ref) => null);
