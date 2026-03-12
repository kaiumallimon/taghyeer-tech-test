class PostReactions {
  final int likes;
  final int dislikes;

  const PostReactions({
    required this.likes,
    required this.dislikes,
  });

  factory PostReactions.fromJson(Map<String, dynamic> json) {
    return PostReactions(
      likes: json['likes'] as int,
      dislikes: json['dislikes'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'likes': likes,
        'dislikes': dislikes,
      };
}

class Post {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final PostReactions reactions;
  final int views;
  final int userId;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
    required this.views,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      tags: List<String>.from(json['tags'] as List),
      reactions:
          PostReactions.fromJson(json['reactions'] as Map<String, dynamic>),
      views: json['views'] as int,
      userId: json['userId'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'tags': tags,
        'reactions': reactions.toJson(),
        'views': views,
        'userId': userId,
      };
}
