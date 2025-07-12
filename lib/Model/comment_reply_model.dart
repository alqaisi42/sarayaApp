class CommentReplyResponse {
  bool? error;
  String? message;
  List<Data>? data;

  CommentReplyResponse({this.error, this.message, this.data});

  CommentReplyResponse.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  int? postId;
  int? parentId;
  int? replies;
  String? comment;
  String? createdAt;
  String? updatedAt;
  User? user;

  Data(
      {this.id,
        this.userId,
        this.postId,
        this.parentId,
        this.replies,
        this.comment,
        this.createdAt,
        this.updatedAt,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    postId = json['post_id'];
    parentId = json['parent_id'];
    replies = json['replies'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['post_id'] = postId;
    data['parent_id'] = parentId;
    data['replies'] = replies;
    data['comment'] = comment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? mobile;
  Null emailVerifiedAt;
  String? profile;
  String? type;
  String? fcmId;
  int? notification;
  Null firebaseId;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null deletedAt;
  String? countryCode;

  User(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.emailVerifiedAt,
        this.profile,
        this.type,
        this.fcmId,
        this.notification,
        this.firebaseId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.countryCode});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    emailVerifiedAt = json['email_verified_at'];
    profile = json['profile'];
    type = json['type'];
    fcmId = json['fcm_id'];
    notification = json['notification'];
    firebaseId = json['firebase_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['email_verified_at'] = emailVerifiedAt;
    data['profile'] = profile;
    data['type'] = type;
    data['fcm_id'] = fcmId;
    data['notification'] = notification;
    data['firebase_id'] = firebaseId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['country_code'] = countryCode;
    return data;
  }
}
