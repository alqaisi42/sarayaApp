class NotificationModel {
  bool? error;
  String? message;
  Data? data;

  NotificationModel({this.error, this.message, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
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
  bool? isAllRead;
  List<Notification>? notification;

  Data({this.isAllRead, this.notification});

  Data.fromJson(Map<String, dynamic> json) {
    isAllRead = json['isAllRead'];
    if (json['notification'] != null) {
      notification = <Notification>[];
      json['notification'].forEach((v) {
        notification!.add(Notification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isAllRead'] = isAllRead;
    if (notification != null) {
      data['notification'] = notification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notification {
  int? id;
  int? isRead;
  String? channelLogo;
  String? slug;
  String? title;
  String? message;
  String? image;
  String? createdAt;

  Notification({
    this.id,
    this.isRead,
    this.channelLogo,
    this.slug,
    this.title,
    this.message,
    this.image,
    this.createdAt,
  });

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isRead = json['isRead'];
    channelLogo = json['channel_logo'];
    slug = json['slug'];
    title = json['title'];
    message = json['message'];
    image = json['image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isRead'] = isRead;
    data['channel_logo'] = channelLogo;
    data['slug'] = slug;
    data['title'] = title;
    data['message'] = message;
    data['image'] = image;
    data['created_at'] = createdAt;
    return data;
  }
}
