class CommentsGetResponse {
  final CommentData? data;
  final String? message;
  final bool? success;

  CommentsGetResponse({
    this.data,
    this.message,
    this.success,
  });

  factory CommentsGetResponse.fromJson(Map<String, dynamic> json) {
    return CommentsGetResponse(
      data: json['data'] != null ? CommentData.fromJson(json['data']) : null,
      message: json['message'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'message': message,
      'success': success,
    };
  }
}

class CommentData {
  final List<Comment>? comment;
  final int? count;

  CommentData({
    this.comment,
    this.count,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      comment: json['comment'] != null
          ? List<Comment>.from(json['comment'].map((x) => Comment.fromJson(x)))
          : null,
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment': comment?.map((x) => x.toJson()).toList(),
      'count': count,
    };
  }
}

class Comment {
  final int id;
  final String? text;
  final String? createdAt;
  final int replies;
  final CommentUser user;

  Comment({
    required this.id,
    this.text,
    this.createdAt,
    required this.replies,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      createdAt: json['created_at'],
      replies: json['replies'] ?? 0,
      user: CommentUser.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'created_at': createdAt,
      'replies': replies,
      'user': user.toJson(),
    };
  }
}

class CommentUser {
  final int id;
  final String? name;
  final String? profile;

  CommentUser({
    required this.id,
    this.name,
    this.profile,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['id'],
      name: json['name'],
      profile: json['profile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile': profile,
    };
  }
}
