class FollowAndUnfollowResponse {
  bool? error;
  String? status;
  String? channelSlug;
  String? message;
  int? isFollow;

  FollowAndUnfollowResponse(
      {this.error, this.status, this.channelSlug, this.message,this.isFollow});

  FollowAndUnfollowResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    status = json['status'];
    channelSlug = json['channel_slug'];
    message = json['message'];
    isFollow = json['isFollow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['status'] = status;
    data['channel_slug'] = channelSlug;
    data['message'] = message;
    data['isFollow'] = isFollow;
    return data;
  }
}
