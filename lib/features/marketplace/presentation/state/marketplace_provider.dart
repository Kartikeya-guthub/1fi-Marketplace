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

// --- Fetch all products ---
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(marketplaceRepositoryProvider);
  return repo.getProducts();
});

// --- Fetch single product by ID ---
final productByIdProvider = FutureProvider.family<Product, String>((ref, id) async {
  final repo = ref.watch(marketplaceRepositoryProvider);
  return repo.getProductById(id);
});
