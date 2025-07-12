class DeleteCommentResponse {
  bool? error;
  String? message;
  String? commentId;

  DeleteCommentResponse({this.error, this.message, this.commentId});

  DeleteCommentResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    commentId = json['comment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    data['comment_id'] = commentId;
    return data;
  }
}
