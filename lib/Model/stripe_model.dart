class StripeResModel {
  bool? error;
  String? message;
  Data? data;

  StripeResModel({this.error, this.message, this.data});

  StripeResModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
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
  String? checkoutUrl;

  Data({this.checkoutUrl});

  Data.fromJson(Map<String, dynamic> json) {
    checkoutUrl = json['checkout_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['checkout_url'] = checkoutUrl;
    return data;
  }
}
