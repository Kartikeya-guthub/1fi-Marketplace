import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/marketplace_api.dart';
import '../../data/marketplace_repository.dart';
import '../../data/mock_marketplace_api.dart';
import '../../data/models/models.dart';

// --- API & Repository ---
final marketplaceApiProvider = Provider<MarketplaceApi>((ref) {
  return MockMarketplaceApi();
});

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  final api = ref.watch(marketplaceApiProvider);
  return MarketplaceRepository(api);
});

// --- Search State ---
final searchQueryProvider = StateProvider<String>((ref) => '');

// --- Fetch all products (Runs only once) ---
final _allProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(marketplaceRepositoryProvider);
  return repo.getProducts();
});

// --- Filtered products (Synchronous) ---
final productsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(_allProductsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return productsAsync.whenData((products) {
    if (query.isEmpty) return products;
    return products.where((product) => 
      product.name.toLowerCase().contains(query) ||
      product.sellerName.toLowerCase().contains(query) ||
      product.category.toLowerCase().contains(query)
    ).toList();
  });
});

// --- Fetch single product by ID ---
final productByIdProvider = FutureProvider.family<Product, String>((ref, id) async {
  final repo = ref.watch(marketplaceRepositoryProvider);
  return repo.getProductById(id);
});
