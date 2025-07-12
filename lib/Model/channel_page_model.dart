class ChannelPageResponse {
  bool? error;
  String? message;
  Data? data;

  ChannelPageResponse({this.error, this.message, this.data});

  ChannelPageResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? logo;
  String? description;
  String? slug;
  int? followCount;
  int? isFollowed;
  int? totalPost;
  List<TopicsList>? topicsList;
  String? postImage;

  Data(
      {this.id,
        this.name,
        this.logo,
        this.description,
        this.slug,
        this.followCount,
        this.isFollowed,
        this.totalPost,
        this.topicsList,
        this.postImage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    description = json['description'];
    slug = json['slug'];
    followCount = json['follow_count'];
    isFollowed = json['is_followed'];
    totalPost = json['total_post'];
    if (json['topics_list'] != null) {
      topicsList = <TopicsList>[];
      json['topics_list'].forEach((v) {
        topicsList!.add(TopicsList.fromJson(v));
      });
    }
    postImage = json['post_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    data['description'] = description;
    data['slug'] = slug;
    data['follow_count'] = followCount;
    data['is_followed'] = isFollowed;
    data['total_post'] = totalPost;
    if (topicsList != null) {
      data['topics_list'] = topicsList!.map((v) => v.toJson()).toList();
    }
    data['post_image'] = postImage;
    return data;
  }
}

class TopicsList {
  int? id;
  String? name;
  String? slug;

  TopicsList({this.id, this.name, this.slug});

  TopicsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}
