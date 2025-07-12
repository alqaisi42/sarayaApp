class GetSettingsResponse {
  bool? error;
  String? message;
  List<Data>? data;

  GetSettingsResponse({this.error, this.message, this.data});

  GetSettingsResponse.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? value;

  Data({this.name, this.value});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name ?? "";
    data['value'] = value ?? "";
    return data;
  }
}
