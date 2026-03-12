import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:taghyeer_test/core/constants/_app_constants.dart';
import 'package:taghyeer_test/core/storage/_local_storage.dart';

class DioClient {
  DioClient._privateConstructor() {
    _setupInterceptors();
  }

  static final DioClient _instance = DioClient._privateConstructor();

  factory DioClient() => _instance;

  // Called by AuthCubit to force logout when refresh fails
  VoidCallback? onUnauthorized;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: Duration(seconds: AppConstants.apiConnectTimeoutSeconds),
      receiveTimeout: Duration(seconds: AppConstants.apiReceiveTimeoutSeconds),
    ),
  );

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = LocalStorage.fetchAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (err, handler) async {
          if (err.response?.statusCode == 401) {
            try {
              final storedRefreshToken = LocalStorage.fetchRefreshToken();
              if (storedRefreshToken == null) {
                await LocalStorage.clearAll();
                onUnauthorized?.call();
                return handler.next(err);
              }

              // Use a fresh Dio to avoid interceptor recursion
              final refreshDio = Dio(
                BaseOptions(
                  baseUrl: AppConstants.apiBaseUrl,
                  connectTimeout: Duration(
                      seconds: AppConstants.apiConnectTimeoutSeconds),
                  receiveTimeout: Duration(
                      seconds: AppConstants.apiReceiveTimeoutSeconds),
                ),
              );

              final refreshResponse = await refreshDio.post(
                AppConstants.refreshTokenEndpoint,
                data: {'refreshToken': storedRefreshToken, 'expiresInMins': 30},
              );

              final newAccessToken =
                  refreshResponse.data['accessToken'] as String;
              final newRefreshToken =
                  refreshResponse.data['refreshToken'] as String;

              await LocalStorage.saveTokens(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
              );

              // Retry original request with new token
              err.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              final retryResponse = await dio.fetch(err.requestOptions);
              return handler.resolve(retryResponse);
            } catch (_) {
              await LocalStorage.clearAll();
              onUnauthorized?.call();
              return handler.next(err);
            }
          }
          handler.next(err);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await dio.get(path, queryParameters: queryParams);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }
}
