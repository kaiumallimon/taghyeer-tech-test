import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_test/features/dashboard/products/bloc/_product_state.dart';
import 'package:taghyeer_test/features/dashboard/products/models/_product_model.dart';
import 'package:taghyeer_test/features/dashboard/products/repository/_product_repository.dart';

class ProductNoInternetException implements Exception {
  const ProductNoInternetException();
}

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repo;

  ProductCubit(this.repo) : super(ProductInitial());

  static const int pageSize = 10;

  Future<List<Product>> fetchPage(int skip) async {
    try {
      return await repo.fetchProducts(skip: skip, limit: pageSize);
    } on DioException catch (e) {
      final isNoInternet =
          e.type == DioExceptionType.connectionError ||
          e.error is SocketException;
      throw isNoInternet ? const ProductNoInternetException() : e;
    }
  }
}
