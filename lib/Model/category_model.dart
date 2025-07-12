class CategoryResponse {
  bool? error;
  String? message;
  List<Data>? data;

  CategoryResponse({this.error, this.message, this.data});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  CategoryResponse copyWith({
    bool? error,
    String? message,
    List<Data>? data,
  }) {
    return CategoryResponse(
      error: error ?? this.error,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class Data {
  int? id;
  int? viewCount;
  String? channelName;
  String? channelLogo;
  String? topicName;
  String? slug;
  String? title;
  String? image;
  String? pubdate;
  int? isFavorite;
  String? channelSlug;
  String? publishDate;

  Data({
    this.id,
    this.viewCount,
    this.channelName,
    this.channelLogo,
    this.topicName,
    this.slug,
    this.title,
    this.image,
    this.pubdate,
    this.isFavorite,
    this.channelSlug,
    this.publishDate
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    viewCount = json['view_count'];
    channelName = json['channel_name'];
    channelLogo = json['channel_logo'];
    topicName = json['topic_name'];
    slug = json['slug'];
    title = json['title'];
    image = json['image'];
    pubdate = json['pubdate'];
    isFavorite = json['is_favorite'];
    channelSlug = json['channel_slug'];
    publishDate = json['publish_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['view_count'] = viewCount;
    data['channel_name'] = channelName;
    data['channel_logo'] = channelLogo;
    data['topic_name'] = topicName;
    data['slug'] = slug;
    data['title'] = title;
    data['image'] = image;
    data['pubdate'] = pubdate;
    data['is_favorite'] = isFavorite;
    data['channel_slug'] = channelSlug;
    data['publish_date'] = publishDate;
    return data;
  }

  Data copyWith({
    int? id,
    int? viewCount,
    String? channelName,
    String? channelLogo,
    String? topicName,
    String? slug,
    String? title,
    String? image,
    String? pubdate,
    int? isFavorite,
    String? channelSlug,
    String? publishDate,
  }) {
    return Data(
      id: id ?? this.id,
      viewCount: viewCount ?? this.viewCount,
      channelName: channelName ?? this.channelName,
      channelLogo: channelLogo ?? this.channelLogo,
      topicName: topicName ?? this.topicName,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      image: image ?? this.image,
      pubdate: pubdate ?? this.pubdate,
      isFavorite: isFavorite ?? this.isFavorite,
      channelSlug: channelSlug ?? this.channelSlug,
      publishDate: publishDate ?? this.publishDate
    );
  }
}
