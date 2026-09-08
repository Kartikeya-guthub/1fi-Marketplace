import 'package:flutter/material.dart';
import '../../../../core/utils/format_inr.dart';
import '../../../../core/widgets/info_list_card.dart';
import '../../data/models/models.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double minMonthlyEmi;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.minMonthlyEmi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InfoListCard(
      title: product.name,
      subtitle: minMonthlyEmi > 0 
          ? 'Sold by ${product.sellerName}\nNo-cost EMIs from ${formatINRCompact(minMonthlyEmi)}/mo'
          : 'Sold by ${product.sellerName}',
      imageUrl: product.imageUrl,

      onTap: onTap,
    );
  }
}


