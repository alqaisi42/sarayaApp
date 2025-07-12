class SearchResultResponse {
  bool? error;
  List<Data>? data;

  SearchResultResponse({this.error, this.data});

  SearchResultResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? favorite;
  String? image;
  String? title;
  String? slug;
  int? viewCount;
  String? channelName;
  String? channelLogo;
  String? channelSlug;
  String? topicName;
  String? topicSlug;
  String? publishDate;
  int? isFavorite;
  String? type;
  String? videoThumb;
  String? video;

  Data(
      {this.id,
        this.favorite,
        this.image,
        this.title,
        this.slug,
        this.channelName,
        this.channelLogo,
        this.channelSlug,
        this.topicName,
        this.topicSlug,
        this.publishDate,
        this.isFavorite,
        this.viewCount,
        this.video,
        this.videoThumb,
        this.type
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    favorite = json['favorite'];
    image = json['image'];
    title = json['title'];
    slug = json['slug'];
    channelName = json['channel_name'];
    channelLogo = json['channel_logo'];
    channelSlug = json['channel_slug'];
    topicName = json['topic_name'];
    topicSlug = json['topic_slug'];
    publishDate = json['publish_date'];
    isFavorite = json['is_favorite'];
    viewCount = json['view_count'];
    type = json['type'];
    videoThumb = json['video_thumb'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['favorite'] = favorite;
    data['image'] = image;
    data['title'] = title;
    data['slug'] = slug;
    data['channel_name'] = channelName;
    data['channel_logo'] = channelLogo;
    data['channel_slug'] = channelSlug;
    data['topic_name'] = topicName;
    data['topic_slug'] = topicSlug;
    data['pubdate'] = publishDate;
    data['is_favorite'] = isFavorite;
    data['view_count'] = viewCount;
    data['type'] = type;
    data['video_thumb'] = videoThumb;
    data['video'] = video;
    return data;
  }
}
