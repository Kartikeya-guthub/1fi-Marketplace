import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/format_inr.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/filter_pill.dart';
import '../../../../core/widgets/search_field.dart';
import '../state/marketplace_provider.dart';
import 'product_details_page.dart';
import '../widgets/product_card.dart';

class MarketplaceTab extends ConsumerWidget {
  const MarketplaceTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SearchField(hintText: 'Search products...'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Marketplace',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const FilterPill(label: 'All Categories'),
            ],
          ),
        ),
        // Removed Expanded so it can fit inside SingleChildScrollView
        productsAsyncValue.when(
          loading: () => const AppSkeleton(),
          error: (error, stack) => ErrorStateWidget(
            onRetry: () => ref.refresh(productsProvider),
          ),
          data: (products) {
            if (products.isEmpty) {
              return const EmptyStateWidget();
            }
            
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              shrinkWrap: true, // Crucial for nested scroll views
              physics: const NeverScrollableScrollPhysics(), // Disables inner scrolling
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                
                // Extract minimum monthly EMI
                double minEmi = 0;
                if (product.emiPlans.isNotEmpty) {
                  minEmi = product.emiPlans
                      .map((p) => p.monthlyAmount)
                      .reduce((a, b) => a < b ? a : b);
                }

                return ProductCard(
                  product: product,
                  minMonthlyEmi: minEmi,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(productId: product.id),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
