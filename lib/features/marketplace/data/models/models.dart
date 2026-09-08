class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double basePrice;
  final String category;
  final String sellerName;
  final List<ProductVariant> variants;
  final List<EmiPlan> emiPlans;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.basePrice,
    required this.category,
    this.sellerName = '1Fi Trusted Seller',
    this.variants = const [],
    this.emiPlans = const [],
  });
}

class ProductVariant {
  final String id;
  final String name;
  final String colorHex;
  final String? imageUrl;
  final double? priceAdjustment;
  final bool available;

  const ProductVariant({
    required this.id,
    required this.name,
    required this.colorHex,
    this.imageUrl,
    this.priceAdjustment,
    this.available = true,
  });
}

class EmiPlan {
  final String id;
  final int tenureMonths;
  final double monthlyAmount;
  final double totalAmount;
  final double interestRate;
  final bool isNoCost;

  const EmiPlan({
    required this.id,
    required this.tenureMonths,
    required this.monthlyAmount,
    required this.totalAmount,
    required this.interestRate,
    this.isNoCost = false,
  });
}
