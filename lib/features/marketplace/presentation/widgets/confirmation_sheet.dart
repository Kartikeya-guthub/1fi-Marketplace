import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_inr.dart';
import '../../data/models/models.dart';

class ConfirmationSheet extends StatelessWidget {
  final Product product;
  final ProductVariant? selectedVariant;
  final EmiPlan selectedPlan;

  const ConfirmationSheet({
    super.key,
    required this.product,
    this.selectedVariant,
    required this.selectedPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'EMI Plan Selected',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bodyBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (selectedVariant != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Variant: ${selectedVariant!.name}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monthly EMI',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${formatINR(selectedPlan.monthlyAmount)} x ${selectedPlan.tenureMonths}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close sheet
                Navigator.of(context).pop(); // Go back to marketplace
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
