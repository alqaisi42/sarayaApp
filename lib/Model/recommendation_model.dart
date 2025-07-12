class RecommedationResponse {
  bool? error;
  String? message;
  List<Data>? data;
  bool? isAdsFree;


  RecommedationResponse({this.error, this.message, this.data,this.isAdsFree});

  RecommedationResponse.fromJson(Map<String, dynamic> json) {
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
  int? viewCount;
  String? channelName;
  String? channelSlug;
  String? channelLogo;
  String? topicName;
  String? title;
  String? image;
  String? pubdate;
  String? slug;
  int? isFavorite;
  String? publishDate;
  String? postType;
  String? videoThumb;
  String? videoUrl;



  Data(
      {this.id,
        this.viewCount,
        this.channelName,
        this.channelLogo,
        this.topicName,
        this.title,
        this.image,
        this.pubdate,
        this.slug,
        this.channelSlug,
        this.isFavorite,
        this.publishDate,
        this.postType,
        this.videoUrl,
        this.videoThumb

      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    viewCount = json['view_count'];
    channelName = json['channel_name'];
    channelLogo = json['channel_logo'];
    channelSlug = json['channel_slug'];
    topicName = json['topic_name'];
    title = json['title'];
    image = json['image'];
    pubdate = json['pubdate'];
    slug = json['slug'];
    isFavorite = json['is_favorite'];
    publishDate = json['publish_date'];
    postType = json['type'];
    videoThumb = json['video_thumb'];
    videoUrl = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['view_count'] = viewCount;
    data['channel_name'] = channelName;
    data['channel_slug'] = channelSlug;
    data['channel_logo'] = channelLogo;
    data['topic_name'] = topicName;
    data['title'] = title;
    data['image'] = image;
    data['pubdate'] = pubdate;
    data['slug'] = slug;
    data['is_favorite'] = isFavorite;
    data['publish_date'] = publishDate;
    data['type'] = postType;
    data['video_thumb'] = videoThumb;
    data['video'] = videoUrl;

    return data;
  }
}
