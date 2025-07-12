class UpdateProfileResponse {
  bool? error;
  String? message;
  Data? data;

  UpdateProfileResponse({this.error, this.message, this.data});

  UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? mobile;
  String? emailVerifiedAt;
  String? profile;
  String? type;
  String? fcmId;
  int? notification;
  String? firebaseId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? countryCode;

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
