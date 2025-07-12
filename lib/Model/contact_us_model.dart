class ContactUsModel {
  bool? status;
  List<Data>? data;
  String? message;

  ContactUsModel({this.status, this.data, this.message});

  ContactUsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((item) => Data.fromJson(item ?? {}))
          .toList();
    } else {
      data = [];
    }
    message = json['message'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}


class Data {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? message;
  String? createdAt;

  Data({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.message,
    this.createdAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    message = json['message'] ?? '';
    createdAt = json['created_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['message'] = message;
    data['created_at'] = createdAt;
    return data;
  }
}

