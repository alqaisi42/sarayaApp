class PopularHomeResponse {
  bool? error;
  String? message;
  List<Data>? data;
  bool? isAdsFree;

  PopularHomeResponse({this.error, this.message, this.data,this.isAdsFree});



  PopularHomeResponse copyWith({
    bool? error,
    String? message,
    List<Data>? data,
    bool? isAdsFree,
  }) {
    return PopularHomeResponse(
      error: error ?? this.error,
      message: message ?? this.message,

      data: data ?? this.data,
        isAdsFree : isAdsFree ?? this.isAdsFree
    );
  }


  PopularHomeResponse.fromJson(Map<String, dynamic> json) {
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
  String? channelName;
  String? channelLogo;
  String? topicName;
  String? slug;
  String? title;
  String? image;
  int? comment;
  int? favorite;
  int? viewCount;
  String? pubdate;
  int? isFavorite;
  String? channelSlug;
  String? publishDate;
  String? type;
  String? videoThumb;
  String? video;

  Data(
      {this.id,
        this.channelName,
        this.channelLogo,
        this.topicName,
        this.slug,
        this.title,
        this.image,
        this.comment,
        this.favorite,
        this.viewCount,
        this.pubdate,
        this.isFavorite,
        this.channelSlug,
        this.publishDate,
        this.type,
        this.videoThumb,
        this.video
      });

  Data copyWith({
    int? id,
    String? channelName,
    String? channelLogo,
    String? topicName,
    String? slug,
    String? title,
    String? image,
    int? comment,
    int? favorite,
    int? viewCount,
    String? pubdate,
    int? isFavorite,
    String? channelSlug,
    String? publishDate,
    String? type,
    String? videoThumb,
    String? video,

  }) {
    return Data(
      id: id ?? this.id,
      channelName: channelName ?? this.channelName,
      channelLogo: channelLogo ?? this.channelLogo,
      topicName: topicName ?? this.topicName,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      image: image ?? this.image,
      comment: comment ?? this.comment,
      favorite: favorite ?? this.favorite,
      viewCount: viewCount ?? this.viewCount,
      pubdate: pubdate ?? this.pubdate,
      isFavorite: isFavorite ?? this.isFavorite,
      channelSlug: channelSlug ?? this.channelSlug,
        publishDate: publishDate ?? this.publishDate,
      type: type ?? this.type,
       videoThumb : videoThumb ?? this.videoThumb,
      video : video ?? this.video
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelName = json['channel_name'];
    channelLogo = json['channel_logo'];
    topicName = json['topic_name'];
    slug = json['slug'];
    title = json['title'];
    image = json['image'];
    comment = json['comment'];
    favorite = json['favorite'];
    viewCount = json['view_count'];
    pubdate = json['pubdate'];
    isFavorite = json['is_favorite'];
    channelSlug = json['channel_slug'];
    publishDate = json['publish_date'];
    type = json['type'];
    videoThumb = json['video_thumb'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['channel_name'] = channelName;
    data['channel_logo'] = channelLogo;
    data['topic_name'] = topicName;
    data['slug'] = slug;
    data['title'] = title;
    data['image'] = image;
    data['comment'] = comment;
    data['favorite'] = favorite;
    data['view_count'] = viewCount;
    data['pubdate'] = pubdate;
    data['is_favorite'] = isFavorite;
    data['channel_slug'] = channelSlug;
    data['publish_date'] = publishDate;
    data['type'] = type;
    data['video_thumb'] = videoThumb;
    data['video'] = video;
    return data;
  }
}
