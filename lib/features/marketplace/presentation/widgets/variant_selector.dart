import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/models.dart';

class VariantSelector extends StatelessWidget {
  final List<ProductVariant> variants;
  final String? selectedVariantId;
  final ValueChanged<String> onVariantSelected;

  const VariantSelector({
    super.key,
    required this.variants,
    required this.selectedVariantId,
    required this.onVariantSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (variants.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Color',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: variants.map((variant) {
              final isSelected = variant.id == selectedVariantId;
              // Parse hex string (e.g. #FFFFFF)
              Color color;
              try {
                final hex = variant.colorHex.replaceAll('#', '');
                color = Color(int.parse('FF$hex', radix: 16));
              } catch (_) {
                color = Colors.grey;
              }

              return GestureDetector(
                onTap: variant.available ? () => onVariantSelected(variant.id) : null,
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primaryPurple : AppColors.cardBorder,
                            width: isSelected ? 3 : 1,
                          ),
                          boxShadow: [
                            if (!variant.available)
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                spreadRadius: 2,
                              ),
                          ],
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        variant.name,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              decoration: variant.available ? null : TextDecoration.lineThrough,
                              color: variant.available ? AppColors.textPrimary : AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
