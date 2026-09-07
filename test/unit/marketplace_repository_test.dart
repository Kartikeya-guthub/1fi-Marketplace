import 'package:flutter_test/flutter_test.dart';
import 'package:onefi_marketplace/features/marketplace/data/marketplace_repository.dart';
import 'package:onefi_marketplace/features/marketplace/data/mock_marketplace_api.dart';

void main() {
  group('MarketplaceRepository', () {
    late MockMarketplaceApi mockApi;
    late MarketplaceRepository repository;

    setUp(() {
      mockApi = MockMarketplaceApi();
      repository = MarketplaceRepository(mockApi);
    });

    test('getProducts returns a list of products', () async {
      final products = await repository.getProducts();
      
      expect(products, isNotEmpty);
      expect(products.first.name, 'iPhone 16 Pro'); // First mock item
      expect(products.length, 3);
    });

    test('getProductById returns the correct product', () async {
      final product = await repository.getProductById('p2');
      
      expect(product.id, 'p2');
      expect(product.name, 'MacBook Air M3');
    });

    test('getProducts handles failures gracefully', () async {
      mockApi.shouldFail = true;
      
      expect(
        () => repository.getProducts(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
