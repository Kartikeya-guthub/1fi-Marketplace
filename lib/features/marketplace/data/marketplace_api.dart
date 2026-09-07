import 'models/models.dart';

abstract class MarketplaceApi {
  Future<List<Product>> fetchProducts();
  Future<Product> fetchProductById(String id);
}
