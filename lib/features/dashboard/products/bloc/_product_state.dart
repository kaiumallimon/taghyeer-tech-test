import 'package:taghyeer_test/features/dashboard/products/models/_product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;

  ProductLoaded(this.products, this.hasMore, {this.isLoadingMore = false});
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}

class ProductNoInternet extends ProductState {}