import 'package:taghyeer_test/core/constants/_app_constants.dart';
import 'package:taghyeer_test/core/network/_dio_client.dart';
import 'package:taghyeer_test/features/dashboard/products/models/_product_model.dart';

class ProductRepository {
  final DioClient _api;

  ProductRepository(this._api);

  Future<List<Product>> fetchProducts({
    required int skip,
    required int limit,
  }) async {
    final response = await _api.get(
      AppConstants.productsEndpoint,
      queryParams: {"skip": skip, "limit": limit},
    );

    return response.data['products']
        .map<Product>((json) => Product.fromJson(json))
        .toList();
  }
}
