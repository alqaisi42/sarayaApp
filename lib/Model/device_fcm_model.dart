class DeviceFCMResponse {
  bool? error;
  String? message;
  Data? data;

  DeviceFCMResponse({this.error, this.message, this.data});

  DeviceFCMResponse.fromJson(Map<String, dynamic> json) {
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
  String? fcmId;

  Data({this.fcmId});

  Data.fromJson(Map<String, dynamic> json) {
    fcmId = json['fcm_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fcm_id'] = fcmId;
    return data;
  }
}
