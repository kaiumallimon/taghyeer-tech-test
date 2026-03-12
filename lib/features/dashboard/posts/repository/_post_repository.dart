import 'package:taghyeer_test/core/constants/_app_constants.dart';
import 'package:taghyeer_test/core/network/_dio_client.dart';
import 'package:taghyeer_test/features/dashboard/posts/models/_post_model.dart';

class PostRepository {
  final DioClient _api;

  PostRepository(this._api);

  Future<List<Post>> fetchPosts({
    required int skip,
    required int limit,
  }) async {
    final response = await _api.get(
      AppConstants.postsEndpoint,
      queryParams: {"skip": skip, "limit": limit},
    );

    return response.data['posts']
        .map<Post>((json) => Post.fromJson(json))
        .toList();
  }
}
