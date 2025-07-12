class ReactEmojiReponse {
  bool? error;
  String? message;
  Data? data;

  ReactEmojiReponse({this.error, this.message, this.data});

  ReactEmojiReponse.fromJson(Map<String, dynamic> json) {
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
  int? count;
  List<UpdateReactionsData>? reactions;
  bool? userHasReacted;

  Data({this.count, this.reactions,this.userHasReacted});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    userHasReacted = json['user_has_reacted'];
    if (json['reactions'] != null) {
      reactions = <UpdateReactionsData>[];
      json['reactions'].forEach((v) {
        reactions!.add(UpdateReactionsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['user_has_reacted'] = userHasReacted;
    if (reactions != null) {
      data['reactions'] = reactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpdateReactionsData {
  String? name;
  int? count;

  UpdateReactionsData({this.name, this.count});

  UpdateReactionsData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    // Explicitly convert to int
    count = json['count'] != null ? (json['count'] as num).toInt() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['count'] = count;
    return data;
  }
}

// class UpdateReactionsData {
//   String? name;
//   int? count;
//
//   UpdateReactionsData({this.name, this.count});
//
//   UpdateReactionsData.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     count = json['count'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['count'] = count;
//     return data;
//   }
// }
