class DetailPageResponse {
  bool? error;
  String? message;
  String? newsLanguageCode;
  Data? data;
  bool? isAdsFree;

  DetailPageResponse({this.error, this.message, this.data,this.isAdsFree,this.newsLanguageCode});

  DetailPageResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    isAdsFree = json['is_ads_free'];
    newsLanguageCode = json['news_language_code'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    data['is_ads_free'] = isAdsFree;
    data['news_language_code'] = newsLanguageCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? channelName;
  String? channelLogo;
  String? topicName;
  String? topicSlug;
  String? channelSlug;
  String? title;
  String? slug;
  String? image;
  String? description;
  String? status;
  String? pubdate;
  int? viewCount;
  int? reaction;
  int? shere;
  int? comment;
  int? favorite;
  int? isFavorite;
  String? publishDate;
  String? resource;
  String? emojiType;
  String? postType;
  String? videoThumb;
  String? video;
  bool? userHasReacted;
  Map<int, UserReaction>? reactionList;
  List<ReletedPost>? reletedPost;



  Data({
    this.id,
    this.channelName,
    this.channelLogo,
    this.topicName,
    this.topicSlug,
    this.title,
    this.slug,
    this.image,
    this.description,
    this.status,
    this.pubdate,
    this.viewCount,
    this.reaction,
    this.shere,
    this.comment,
    this.favorite,
    this.isFavorite,
    this.channelSlug,
    this.publishDate,
    this.resource,
    this.emojiType,
    this.userHasReacted,
    this.reactionList,
    this.video,
    this.videoThumb,
    this.postType,
    this.reletedPost
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelName = json['channel_name'];
    channelLogo = json['channel_logo'];
    topicName = json['topic_name'];
    topicSlug = json['topic_slug'];
    title = json['title'];
    slug = json['slug'];
    image = json['image'];
    description = json['description'];
    status = json['status'];
    pubdate = json['pubdate'];
    viewCount = json['view_count'];
    reaction = json['reaction'];
    shere = json['shere'];
    comment = json['comment'];
    favorite = json['favorite'];
    isFavorite = json['is_favorite'];
    channelSlug = json['channel_slug'];
    publishDate = json['publish_date'];
    resource = json['resource'];
    emojiType = json['emoji_type'];
    userHasReacted = json['user_has_reacted'];
    video = json['video'];
    postType = json['type'];
    videoThumb = json['video_thumb'];

    if (json['releted_post'] != null) {
      reletedPost = <ReletedPost>[];
      json['releted_post'].forEach((v) {
        reletedPost!.add(ReletedPost.fromJson(v));
      });
    }

    if (json['reaction_list'] != null) {
      if (json['reaction_list'] is List) {
        reactionList = (json['reaction_list'] as List)
            .asMap()
            .map((key, value) => MapEntry(key, UserReaction.fromJson(value)));
      } else if (json['reaction_list'] is Map) {
        reactionList = (json['reaction_list'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(
            int.parse(key),
            UserReaction.fromJson(value)));
      }
    } else {
      reactionList = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['channel_name'] = channelName;
    data['channel_logo'] = channelLogo;
    data['topic_name'] = topicName;
    data['topic_slug'] = topicSlug;
    data['title'] = title;
    data['slug'] = slug;
    data['image'] = image;
    data['description'] = description;
    data['status'] = status;
    data['pubdate'] = pubdate;
    data['view_count'] = viewCount;
    data['reaction'] = reaction;
    data['shere'] = shere;
    data['comment'] = comment;
    data['favorite'] = favorite;
    data['is_favorite'] = isFavorite;
    data['channel_slug'] = channelSlug;
    data['publish_date'] = publishDate;
    data['resource'] = resource;
    data['emoji_type'] = emojiType;
    data['user_has_reacted'] = userHasReacted;
    data['type'] = postType;
    data['video_thumb'] = videoThumb;
    data['video'] = video;

    if (reletedPost != null) {
      data['releted_post'] = reletedPost!.map((v) => v.toJson()).toList();
    }

    if (reactionList != null) {
      data['reaction_list'] = reactionList!.map((key, value) =>
          MapEntry(key.toString(), value.toJson()));
    }
    return data;
  }
}


class UserReaction {
  String? name;
  int? count;

  UserReaction({this.name, this.count});

  UserReaction.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    // Explicitly convert to int
    count = json['count'] != null ? (json['count'] as num).toInt() : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
    };
  }
}

class ReletedPost {
  int? id;
  String? channelName;
  String? channelSlug;
  String? channelLogo;
  String? topicName;
  String? slug;
  String? type;
  String? title;
  String? videoThumb;
  String? video;
  String? image;
  int? comment;
  int? favorite;
  int? viewCount;
  String? publishDate;
  int? isFavorite;

  ReletedPost(
      {this.id,
        this.channelName,
        this.channelSlug,
        this.channelLogo,
        this.topicName,
        this.slug,
        this.type,
        this.title,
        this.videoThumb,
        this.video,
        this.image,
        this.comment,
        this.favorite,
        this.viewCount,
        this.publishDate,
        this.isFavorite});

  ReletedPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelName = json['channel_name'];
    channelSlug = json['channel_slug'];
    channelLogo = json['channel_logo'];
    topicName = json['topic_name'];
    slug = json['slug'];
    type = json['type'];
    title = json['title'];
    videoThumb = json['video_thumb'];
    video = json['video'];
    image = json['image'];
    comment = json['comment'];
    favorite = json['favorite'];
    viewCount = json['view_count'];
    publishDate = json['publish_date'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['channel_name'] = channelName;
    data['channel_slug'] = channelSlug;
    data['channel_logo'] = channelLogo;
    data['topic_name'] = topicName;
    data['slug'] = slug;
    data['type'] = type;
    data['title'] = title;
    data['video_thumb'] = videoThumb;
    data['video'] = video;
    data['image'] = image;
    data['comment'] = comment;
    data['favorite'] = favorite;
    data['view_count'] = viewCount;
    data['publish_date'] = publishDate;
    data['is_favorite'] = isFavorite;
    return data;
  }
}
