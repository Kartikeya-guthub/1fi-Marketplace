import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_inr.dart';
import '../../data/models/models.dart';

class EmiPlanCard extends StatelessWidget {
  final EmiPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const EmiPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.emiSelectedBg : AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.emiSelectedBorder : AppColors.emiUnselectedBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio button
            Container(
              margin: const EdgeInsets.only(top: 2, right: 16),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryPurple : AppColors.textSecondary,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${plan.tenureMonths} months',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (plan.isNoCost)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.noCostBadgeBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.auto_awesome, size: 12, color: AppColors.noCostBadgeText),
                              const SizedBox(width: 4),
                              Text(
                                'No-cost EMI',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.noCostBadgeText,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${formatINR(plan.monthlyAmount)} / month',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primaryPurple,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total: ${formatINR(plan.totalAmount)}  •  ${plan.interestRate > 0 ? '${plan.interestRate}% p.a.' : '0% interest'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
