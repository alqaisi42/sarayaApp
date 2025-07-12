class UserChannelFollowedListResponse {
  bool? error;
  String? message;
  Data? data;

  UserChannelFollowedListResponse({this.error, this.message, this.data});

  UserChannelFollowedListResponse.fromJson(Map<String, dynamic> json) {
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

  // copyWith method
  UserChannelFollowedListResponse copyWith({
    bool? error,
    String? message,
    Data? data,
  }) {
    return UserChannelFollowedListResponse(
      error: error ?? this.error,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class Data {
  List<Channels>? channels;
  Pagination? pagination;

  Data({this.channels, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['channels'] != null) {
      channels = <Channels>[];
      json['channels'].forEach((v) {
        channels!.add(Channels.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (channels != null) {
      data['channels'] = channels!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }

  // copyWith method
  Data copyWith({
    List<Channels>? channels,
    Pagination? pagination,
  }) {
    return Data(
      channels: channels ?? this.channels,
      pagination: pagination ?? this.pagination,
    );
  }
}

class Channels {
  int? id;
  int? followCount;
  String? name;
  String? slug;
  String? logo;
  String? description;
  int? isFollowed;

  Channels({
    this.id,
    this.followCount,
    this.name,
    this.slug,
    this.logo,
    this.description,
    this.isFollowed,
  });

  Channels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    followCount = json['follow_count'];
    name = json['name'];
    slug = json['slug'];
    logo = json['logo'];
    description = json['description'];
    isFollowed = json['is_followed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['follow_count'] = followCount;
    data['name'] = name;
    data['slug'] = slug;
    data['logo'] = logo;
    data['description'] = description;
    data['is_followed'] = isFollowed;
    return data;
  }

  // copyWith method
  Channels copyWith({
    int? id,
    int? followCount,
    String? name,
    String? slug,
    String? logo,
    String? description,
    int? isFollowed,
  }) {
    return Channels(
      id: id ?? this.id,
      followCount: followCount ?? this.followCount,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      logo: logo ?? this.logo,
      description: description ?? this.description,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  String? nextPageUrl;
  String? prevPageUrl;
  int? from;
  int? to;

  Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.nextPageUrl,
    this.prevPageUrl,
    this.from,
    this.to,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    nextPageUrl = json['next_page_url'];
    prevPageUrl = json['prev_page_url'];


    from = _parseInt(json['from']);
    to = _parseInt(json['to']);
  }


  int? _parseInt(dynamic value) {
    if (value is String && value.isEmpty) {
      return null;
    }
    return value as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    data['total'] = total;
    data['next_page_url'] = nextPageUrl;
    data['prev_page_url'] = prevPageUrl;
    data['from'] = from;
    data['to'] = to;
    return data;
  }

  // copyWith method
  Pagination copyWith({
    int? currentPage,
    int? lastPage,
    int? perPage,
    int? total,
    String? nextPageUrl,
    String? prevPageUrl,
    int? from,
    int? to,
  }) {
    return Pagination(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }
}


// class Pagination {
//   int? currentPage;
//   int? lastPage;
//   int? perPage;
//   int? total;
//   String? nextPageUrl;
//   String? prevPageUrl;
//   int? from;
//   int? to;
//
//   Pagination({
//     this.currentPage,
//     this.lastPage,
//     this.perPage,
//     this.total,
//     this.nextPageUrl,
//     this.prevPageUrl,
//     this.from,
//     this.to,
//   });
//
//   Pagination.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     lastPage = json['last_page'];
//     perPage = json['per_page'];
//     total = json['total'];
//     nextPageUrl = json['next_page_url'];
//     prevPageUrl = json['prev_page_url'];
//     from = json['from'];
//     to = json['to'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['current_page'] = currentPage;
//     data['last_page'] = lastPage;
//     data['per_page'] = perPage;
//     data['total'] = total;
//     data['next_page_url'] = nextPageUrl;
//     data['prev_page_url'] = prevPageUrl;
//     data['from'] = from;
//     data['to'] = to;
//     return data;
//   }
//
//   // copyWith method
//   Pagination copyWith({
//     int? currentPage,
//     int? lastPage,
//     int? perPage,
//     int? total,
//     String? nextPageUrl,
//     String? prevPageUrl,
//     int? from,
//     int? to,
//   }) {
//     return Pagination(
//       currentPage: currentPage ?? this.currentPage,
//       lastPage: lastPage ?? this.lastPage,
//       perPage: perPage ?? this.perPage,
//       total: total ?? this.total,
//       nextPageUrl: nextPageUrl ?? this.nextPageUrl,
//       prevPageUrl: prevPageUrl ?? this.prevPageUrl,
//       from: from ?? this.from,
//       to: to ?? this.to,
//     );
//   }
// }
