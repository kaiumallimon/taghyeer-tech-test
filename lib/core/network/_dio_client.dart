import 'package:dio/dio.dart';
import 'package:taghyeer_test/core/constants/_app_constants.dart';

class DioClient {
  // singleton pattern
  DioClient._privateConstructor();
  static final DioClient _instance = DioClient._privateConstructor();
  factory DioClient() {
    return _instance;
  }
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: Duration(seconds: AppConstants.apiConnectTimeoutSeconds),
      receiveTimeout: Duration(seconds: AppConstants.apiReceiveTimeoutSeconds),
    ),
  );

  // Get Request api
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await dio.get(path, queryParameters: queryParams);
  }

  // Post Request api
  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }
}
