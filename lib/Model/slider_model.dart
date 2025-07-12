class BannerPostsResponse {
  final bool error;
  final String message;
  final List<BannerPost> data;

  BannerPostsResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory BannerPostsResponse.fromJson(Map<String, dynamic> json) {
    return BannerPostsResponse(
      error: json['error'],
      message: json['message'],
      data: List<BannerPost>.from(
          json['data'].map((post) => BannerPost.fromJson(post))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'data': List<dynamic>.from(data.map((post) => post.toJson())),
    };
  }
}

class BannerPost {
  final int? id;
  final int? viewCount;
  final String? channelName;
  final String? topicName;
  final String? title;
  final String? slug;
  final String? image;
  final String? description;
  final String? status;
  final String? pubdate;
  final String? publishDate;

  BannerPost({
    required this.id,
    required this.viewCount,
    required this.channelName,
    required this.topicName,
    required this.title,
    required this.slug,
    required this.image,
    required this.description,
    required this.status,
    required this.pubdate,
    required this.publishDate,
  });

  factory BannerPost.fromJson(Map<String, dynamic> json) {
    return BannerPost(
      id: json['id'],
      viewCount: json['view_count'],
      channelName: json['channel_name'],
      topicName: json['topic_name'],
      title: json['title'],
      slug: json['slug'],
      image: json['image'],
      description: json['description'],
      status: json['status'],
      pubdate: json['pubdate'],
      publishDate: json['publish_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'view_count': viewCount,
      'channel_name': channelName,
      'topic_name': topicName,
      'title': title,
      'slug': slug,
      'image': image,
      'description': description,
      'status': status,
      'pubdate': pubdate,
      'publishDate': publishDate,
    };
  }
}
