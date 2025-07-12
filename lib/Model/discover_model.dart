class DiscoverResponse {
  bool? success;
  String? message;
  List<Data>? data;

  DiscoverResponse({this.success, this.message, this.data});

  DiscoverResponse copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return DiscoverResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }


  DiscoverResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? '';
    if (json['data'] != null && json['data'] is List) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    } else {
      data = [];
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['success'] = success ?? false;
    result['message'] = message ?? '';
    if (data != null && data!.isNotEmpty) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class Data {
  int? id;
  String? image;
  String? title;
  String? description;
  int? favorite;
  String? slug;
  String? pubdate;
  String? channelName;
  String? channelSlug;
  int? isFavorite;

  Data({
    this.id,
    this.image,
    this.title,
    this.description,
    this.favorite,
    this.pubdate,
    this.channelName,
    this.channelSlug,
    this.slug,
    this.isFavorite,
  });

  // Corrected copyWith method
  Data copyWith({
    int? id,
    String? image,
    String? title,
    String? description,
    int? favorite,
    String? slug,
    String? pubdate,
    String? channelName,
    String? channelSlug,
    int? isFavorite,
  }) {
    return Data(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      description: description ?? this.description,
      favorite: favorite ?? this.favorite,
      slug: slug ?? this.slug,
      pubdate: pubdate ?? this.pubdate,
      channelName: channelName ?? this.channelName,
      channelSlug: channelSlug ?? this.channelSlug,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    image = json['image'] ?? '';
    title = json['title'] ?? 'Untitled';
    description = json['description'] ?? '';
    favorite = json['favorite'] ?? 0;
    pubdate = json['pubdate'] ?? '';
    channelName = json['channel_name'] ?? '';
    channelSlug = json['channel_slug'] ?? '';
    slug = json['slug'] ?? '';
    isFavorite = json['is_favorite'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id ?? 0;
    result['image'] = image ?? '';
    result['title'] = title ?? 'Untitled';
    result['description'] = description ?? '';
    result['favorite'] = favorite ?? 0;
    result['pubdate'] = pubdate ?? '';
    result['channel_name'] = channelName ?? '';
    result['channel_slug'] = channelSlug ?? '';
    result['slug'] = slug ?? '';
    result['is_favorite'] = isFavorite ?? 0;
    return result;
  }
}

