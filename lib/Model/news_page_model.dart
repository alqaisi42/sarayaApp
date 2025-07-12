class NewsPageResponse {
  bool? error;
  String? message;
  List<Data>? data;
  bool? isAdsFree;

  NewsPageResponse({this.error, this.message, this.data, this.isAdsFree});

  NewsPageResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    isAdsFree = json['is_ads_free'];
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
    data['is_ads_free'] = isAdsFree;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? slug;
  String? image;
  String? publishDate;
  int? shere;
  int? viewCount;
  int? favorite;
  int? comment;
  String? topicName;
  String? topicSlug;
  String? channelName;
  String? channelSlug;
  String? channelLogo;
  int? isFavorite;

  Data(
      {this.id,
        this.title,
        this.slug,
        this.image,
        this.publishDate,
        this.shere,
        this.viewCount,
        this.favorite,
        this.comment,
        this.topicName,
        this.topicSlug,
        this.channelName,
        this.channelSlug,
        this.channelLogo,
        this.isFavorite});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    image = json['image'];
    publishDate = json['publish_date'];
    shere = json['shere'];
    viewCount = json['view_count'];
    favorite = json['favorite'];
    comment = json['comment'];
    topicName = json['topic_name'];
    topicSlug = json['topic_slug'];
    channelName = json['channel_name'];
    channelSlug = json['channel_slug'];
    channelLogo = json['channel_logo'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['image'] = image;
    data['publish_date'] = publishDate;
    data['shere'] = shere;
    data['view_count'] = viewCount;
    data['favorite'] = favorite;
    data['comment'] = comment;
    data['topic_name'] = topicName;
    data['topic_slug'] = topicSlug;
    data['channel_name'] = channelName;
    data['channel_slug'] = channelSlug;
    data['channel_logo'] = channelLogo;
    data['is_favorite'] = isFavorite;
    return data;
  }
}
