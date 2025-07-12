class MultiLanguageModel {
  bool? status;
  List<Data>? data;
  String? message;

  MultiLanguageModel({this.status, this.data, this.message});

  MultiLanguageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
  String? code;
  String? image;
  String? createdAt;
  String? updatedAt;
  bool? isSelected;

  Data(
      {this.id,
        this.name,
        this.code,
        this.image,
        this.createdAt,
        this.updatedAt,this.isSelected});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
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
    data['code'] = code;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_selected'] = isSelected;
    return data;
  }
}
