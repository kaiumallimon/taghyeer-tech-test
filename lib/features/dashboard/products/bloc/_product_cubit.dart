import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_test/features/dashboard/products/bloc/_product_state.dart';
import 'package:taghyeer_test/features/dashboard/products/models/_product_model.dart';
import 'package:taghyeer_test/features/dashboard/products/repository/_product_repository.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repo;

  ProductCubit(this.repo) : super(ProductInitial());

  static const int _pageSize = 10;

  int _skip = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  final List<Product> _products = [];

  Future<void> loadProducts() async {
    if (!_hasMore || _isLoadingMore) return;

    try {
      if (_products.isEmpty) {
        emit(ProductLoading());
      } else {
        _isLoadingMore = true;
        emit(ProductLoaded(List.from(_products), _hasMore, isLoadingMore: true));
      }

      final newProducts =
          await repo.fetchProducts(skip: _skip, limit: _pageSize);

      if (newProducts.length < _pageSize) {
        _hasMore = false;
      }

      _skip += newProducts.length;
      _products.addAll(newProducts);
      _isLoadingMore = false;

      emit(ProductLoaded(List.from(_products), _hasMore));
    } on DioException catch (e) {
      _isLoadingMore = false;

      final isNoInternet = e.type == DioExceptionType.connectionError ||
          e.error is SocketException;

      if (_products.isEmpty) {
        if (isNoInternet) {
          emit(ProductNoInternet());
        } else {
          emit(ProductError(e.message ?? 'Failed to load products'));
        }
      } else {
        // already showing data, restore state without interrupting the list
        emit(ProductLoaded(List.from(_products), _hasMore));
      }
    } catch (e) {
      _isLoadingMore = false;

      if (_products.isEmpty) {
        emit(ProductError('Something went wrong. Please try again.'));
      } else {
        emit(ProductLoaded(List.from(_products), _hasMore));
      }
    }
  }

  Future<void> refresh() async {
    _skip = 0;
    _hasMore = true;
    _isLoadingMore = false;
    _products.clear();

    await loadProducts();
  }
}
