class MultiLangPostModel {
  bool? error;
  List<Data>? data;
  String? message;

  MultiLangPostModel({this.error, this.data, this.message});

  MultiLangPostModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
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
  int? isActive;
  String? code;
  String? image;
  String? createdAt;
  String? updatedAt;
  bool? isSelected;

  Data(
      {this.id,
        this.name,
        this.isActive,
        this.code,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.isSelected});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
    code = json['code'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_active'] = isActive;
    data['code'] = code;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_selected'] = isSelected;
    return data;
  }
}
