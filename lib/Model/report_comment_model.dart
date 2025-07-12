class ReportCommentResponse {
  bool? error;
  String? message;
  Data? data;

  ReportCommentResponse({this.error, this.message, this.data});

  ReportCommentResponse.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? report;

  Data({this.id, this.report});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    report = json['report'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['report'] = report;
    return data;
  }
}
