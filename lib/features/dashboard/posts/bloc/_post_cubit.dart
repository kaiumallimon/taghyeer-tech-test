import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_test/features/dashboard/posts/bloc/_post_state.dart';
import 'package:taghyeer_test/features/dashboard/posts/models/_post_model.dart';
import 'package:taghyeer_test/features/dashboard/posts/repository/_post_repository.dart';

class PostNoInternetException implements Exception {
  const PostNoInternetException();
}

class PostCubit extends Cubit<PostState> {
  final PostRepository repo;

  PostCubit(this.repo) : super(PostInitial());

  static const int pageSize = 10;

  Future<List<Post>> fetchPage(int skip) async {
    try {
      return await repo.fetchPosts(skip: skip, limit: pageSize);
    } on DioException catch (e) {
      final isNoInternet = e.type == DioExceptionType.connectionError ||
          e.error is SocketException;
      throw isNoInternet ? const PostNoInternetException() : e;
    }
  }
}
