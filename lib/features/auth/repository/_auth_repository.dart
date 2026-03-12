import 'package:taghyeer_test/core/constants/_app_constants.dart';
import 'package:taghyeer_test/core/network/_dio_client.dart';

class AuthRepository {
  final DioClient _api;

  AuthRepository(this._api);

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await _api.post(
      AppConstants.loginApiEndpoint,
      data: {"username": username, "password": password, "expiresInMins": 30},
    );

    return response.data;
  }
}
