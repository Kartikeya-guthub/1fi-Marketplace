import 'marketplace_api.dart';
import 'models/models.dart';

class MarketplaceRepository {
  final MarketplaceApi _api;

  MarketplaceRepository(this._api);

  Future<List<Product>> getProducts() async {
    try {
      return await _api.fetchProducts();
    } catch (e) {
      // In a real app, wrap in a Result/Either type or map to custom exceptions
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      return await _api.fetchProductById(id);
    } catch (e) {
      throw Exception('Failed to fetch product details: $e');
    }
  }
}
