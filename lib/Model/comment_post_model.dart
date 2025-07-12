class CommentPostResponse {
  bool? error;
  String? message;
  Data? data;

  CommentPostResponse({this.error, this.message, this.data});

  CommentPostResponse.fromJson(Map<String, dynamic> json) {
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
  String? postId;
  String? comment;
  String? status;

  Data({this.postId, this.comment, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    comment = json['comment'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = postId;
    data['comment'] = comment;
    data['status'] = status;
    return data;
  }
}
