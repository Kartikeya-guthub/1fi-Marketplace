import 'dart:async';
import 'marketplace_api.dart';
import 'models/models.dart';

class MockMarketplaceApi implements MarketplaceApi {
  bool shouldFail = false;

  @override
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (shouldFail) {
      throw Exception('Simulated network failure');
    }

    return _mockCatalog;
  }

  @override
  Future<Product> fetchProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (shouldFail) {
      throw Exception('Simulated network failure');
    }

    return _mockCatalog.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Product not found'),
    );
  }

  // Hardcoded mock data anchored to 1Fi marketing hero banner.
  final List<Product> _mockCatalog = const [
    Product(
      id: 'p1',
      name: 'iPhone 16 Pro',
      sellerName: 'Apple Premium Reseller',
      description: 'The ultimate iPhone featuring a new titanium design, A18 Pro chip, and advanced camera system.',
      imageUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?q=80&w=600&auto=format&fit=crop', // Stock replacement
      basePrice: 134900,
      category: 'Electronics',
      variants: [
        ProductVariant(id: 'v1_1', name: 'Natural Titanium', colorHex: '#B2B0A9', available: true),
        ProductVariant(id: 'v1_2', name: 'Black Titanium', colorHex: '#424143', available: true),
        ProductVariant(id: 'v1_3', name: 'White Titanium', colorHex: '#F2F1F0', available: false),
      ],
      emiPlans: [
        EmiPlan(id: 'emi1_3', tenureMonths: 3, monthlyAmount: 44966.67, totalAmount: 134900, interestRate: 0, isNoCost: true),
        EmiPlan(id: 'emi1_6', tenureMonths: 6, monthlyAmount: 22483.33, totalAmount: 134900, interestRate: 0, isNoCost: true),
        EmiPlan(id: 'emi1_12', tenureMonths: 12, monthlyAmount: 12050.25, totalAmount: 144603, interestRate: 12.5),
      ],
    ),
    Product(
      id: 'p2',
      name: 'MacBook Air M3',
      sellerName: 'Apple Premium Reseller',
      description: 'Supercharged by M3. The incredibly thin and light MacBook Air features a stunning Liquid Retina display.',
      imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=600&auto=format&fit=crop',
      basePrice: 114900,
      category: 'Electronics',
      variants: [
        ProductVariant(id: 'v2_1', name: 'Midnight', colorHex: '#2E3642', available: true),
        ProductVariant(id: 'v2_2', name: 'Starlight', colorHex: '#E8E2D6', available: true),
      ],
      emiPlans: [
        EmiPlan(id: 'emi2_6', tenureMonths: 6, monthlyAmount: 19150, totalAmount: 114900, interestRate: 0, isNoCost: true),
        EmiPlan(id: 'emi2_12', tenureMonths: 12, monthlyAmount: 9575, totalAmount: 114900, interestRate: 0, isNoCost: true),
        EmiPlan(id: 'emi2_24', tenureMonths: 24, monthlyAmount: 5410.50, totalAmount: 129852, interestRate: 11.5),
      ],
    ),
    Product(
      id: 'p3',
      name: 'Honda Activa 6G',
      sellerName: 'Honda Authorized Dealer',
      description: 'India\'s most loved scooter, now with advanced features and better fuel efficiency.',
      imageUrl: 'https://images.unsplash.com/photo-1558981403-c5f9899a289f?q=80&w=600&auto=format&fit=crop',
      basePrice: 78920,
      category: 'Vehicles',
      variants: [
        ProductVariant(id: 'v3_1', name: 'Pearl White', colorHex: '#FFFFFF', available: true),
        ProductVariant(id: 'v3_2', name: 'Matte Black', colorHex: '#1A1A1A', available: true),
        ProductVariant(id: 'v3_3', name: 'Rebel Red', colorHex: '#C92A2A', available: true, priceAdjustment: 1500),
      ],
      emiPlans: [
        EmiPlan(id: 'emi3_6', tenureMonths: 6, monthlyAmount: 13153.33, totalAmount: 78920, interestRate: 0, isNoCost: true),
        EmiPlan(id: 'emi3_12', tenureMonths: 12, monthlyAmount: 6576.67, totalAmount: 78920, interestRate: 0, isNoCost: true),
        EmiPlan(id: 'emi3_24', tenureMonths: 24, monthlyAmount: 3650.00, totalAmount: 87600, interestRate: 10.5),
      ],
    ),
  ];
}
