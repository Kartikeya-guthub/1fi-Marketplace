import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_inr.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/error_state.dart';
import '../../data/models/models.dart';
import '../state/marketplace_provider.dart';
import '../state/product_details_provider.dart';
import '../widgets/confirmation_sheet.dart';
import '../widgets/emi_plan_card.dart';
import '../widgets/variant_selector.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedVariantIdProvider.notifier).state = null;
      ref.read(selectedEmiPlanIdProvider.notifier).state = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(widget.productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay using 1Fi'),
        centerTitle: false,
      ),
      body: productAsync.when(
        loading: () => const AppSkeleton(),
        error: (error, stack) => ErrorStateWidget(
          onRetry: () => ref.refresh(productByIdProvider(widget.productId)),
        ),
        data: (product) {
          final selectedVarId = ref.watch(selectedVariantIdProvider);
          if (selectedVarId == null && product.variants.isNotEmpty) {
            try {
              final firstAvailable = product.variants.firstWhere((v) => v.available);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(selectedVariantIdProvider.notifier).state = firstAvailable.id;
              });
            } catch (_) {}
          }

          final selectedVariant = product.variants.cast<ProductVariant?>().firstWhere(
            (v) => v?.id == selectedVarId,
            orElse: () => null,
          );

          final selectedEmiId = ref.watch(selectedEmiPlanIdProvider);
          final selectedEmiPlan = product.emiPlans.cast<EmiPlan?>().firstWhere(
            (p) => p?.id == selectedEmiId,
            orElse: () => null,
          );

          final effectivePrice = product.basePrice + (selectedVariant?.priceAdjustment ?? 0);
          final effectiveImage = selectedVariant?.imageUrl ?? product.imageUrl;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                effectiveImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.image,
                                  size: 32,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.badgeBg,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.storefront, size: 12, color: AppColors.primaryPurple),
                                          const SizedBox(width: 4),
                                          Text(
                                            product.sellerName,
                                            style: const TextStyle(fontSize: 10, color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Giant Price Area
                      Center(
                        child: Column(
                          children: [
                            Text(
                              product.category,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Up to 12 months EMIs',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              formatINR(effectivePrice),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),

                      // Variants
                      if (product.variants.isNotEmpty) ...[
                        VariantSelector(
                          variants: product.variants,
                          selectedVariantId: selectedVarId,
                          onVariantSelected: (id) {
                            ref.read(selectedVariantIdProvider.notifier).state = id;
                          },
                        ),
                        const SizedBox(height: 32),
                      ],

                      // EMI Plans
                      if (product.emiPlans.isNotEmpty) ...[
                        Text(
                          'EMI Options',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ...product.emiPlans.map((plan) {
                          return EmiPlanCard(
                            plan: plan,
                            isSelected: plan.id == selectedEmiId,
                            onTap: () {
                              ref.read(selectedEmiPlanIdProvider.notifier).state = plan.id;
                            },
                          );
                        }),
                        const SizedBox(height: 24),
                      ],

                      // Delivery / Pickup Section
                      Text(
                        'Delivery / Pickup',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 20, color: AppColors.primaryPurple),
                                const SizedBox(width: 8),
                                Text(
                                  'Deliver to: Gurgaon, 122001',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estimated delivery: 2–4 days',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Free delivery',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Or: Pickup available',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'How to use',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              
              // Custom Dynamic EMI Bottom Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      // Dynamic Costing Info
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedEmiPlan != null 
                                ? '${formatINR(selectedEmiPlan.monthlyAmount)}/mo'
                                : '--',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                            Text(
                              selectedEmiPlan != null
                                  ? 'For ${selectedEmiPlan.tenureMonths} months'
                                  : 'Select an EMI plan',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Continue Button
                      SizedBox(
                        width: 140,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: selectedEmiPlan != null ? AppColors.primaryPurple : AppColors.divider,
                            foregroundColor: selectedEmiPlan != null ? Colors.white : AppColors.textSecondary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: selectedEmiPlan == null
                              ? null
                              : () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) => ConfirmationSheet(
                                      product: product,
                                      selectedVariant: selectedVariant,
                                      selectedPlan: selectedEmiPlan,
                                    ),
                                  );
                                },
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
