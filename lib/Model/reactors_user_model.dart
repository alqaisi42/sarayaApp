class ReactorsUserModel {
  bool? error;
  String? message;
  List<Data>? data;

  ReactorsUserModel({this.error, this.message, this.data});

  ReactorsUserModel.fromJson(Map<String, dynamic> json) {
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
  String? reactionName;
  String? profile;
  String? userName;

  Data({this.id, this.reactionName, this.profile, this.userName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reactionName = json['reaction_name'];
    profile = json['profile'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reaction_name'] = reactionName;
    data['profile'] = profile;
    data['user_name'] = userName;
    return data;
  }
}
