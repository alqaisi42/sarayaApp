class FevoriteResponse {
  bool? error;
  String? message;
  String? status;
  String? postId;

  FevoriteResponse({this.error, this.message,this.status});

  FevoriteResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    status = json['status'];
    postId = json['postId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    data['status'] = status;
    data['postId'] = postId;
    return data;
  }
}
