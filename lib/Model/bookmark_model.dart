class BookmarkResponse {
  bool? error;
  String? message;
  List<Data>? data;

  BookmarkResponse({this.error, this.message, this.data});

  BookmarkResponse.fromJson(Map<String, dynamic> json) {
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
}

class Data {
  int? id;
  int? postId;
  String? title;
  String? image;
  String? pubdate;
  int? favorite;
  String? isFavorit;
  String? slug;
  String? publishDate;
  String? type;
  String? videoThumb;
  String? video;

  Data(
      {this.id,
        this.postId,
        this.title,
        this.image,
        this.pubdate,
        this.favorite,
        this.isFavorit,
        this.slug,
        this.publishDate,
        this.type,
        this.videoThumb,
        this.video
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    title = json['title'];
    image = json['image'];
    pubdate = json['pubdate'];
    favorite = json['favorite'];
    isFavorit = json['is_favorit'];
    slug = json['slug'];
    publishDate = json['publish_date'];
    type = json['type'];
    videoThumb = json['video_thumb'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['post_id'] = postId;
    data['title'] = title;
    data['image'] = image;
    data['pubdate'] = pubdate;
    data['favorite'] = favorite;
    data['is_favorit'] = isFavorit;
    data['slug'] = slug;
    data['publish_date'] = publishDate;
    data['type'] = type;
    data['video_thumb'] = videoThumb;
    data['video'] = video;
    return data;
  }
}
