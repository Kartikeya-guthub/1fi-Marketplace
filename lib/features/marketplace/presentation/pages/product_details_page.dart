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
    // Clear selections when opening a new product
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
        title: const Text('Product Details'),
      ),
      body: productAsync.when(
        loading: () => const AppSkeleton(),
        error: (error, stack) => ErrorStateWidget(
          onRetry: () => ref.refresh(productByIdProvider(widget.productId)),
        ),
        data: (product) {
          // Initialize default selections if not set
          final selectedVarId = ref.watch(selectedVariantIdProvider);
          if (selectedVarId == null && product.variants.isNotEmpty) {
            // Find first available
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

          // Calculate effective price & image based on variant
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
                      // Product Image
                      Center(
                        child: Container(
                          height: 240,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              effectiveImage,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.image,
                                size: 64,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Title & Price
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatINR(effectivePrice),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Description
                      Text(
                        product.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
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
                          style: Theme.of(context).textTheme.titleMedium,
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
                      ],
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
