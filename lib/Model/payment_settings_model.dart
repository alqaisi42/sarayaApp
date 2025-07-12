class PaymentSettingsModel {
  bool error;
  String message;
  Data data;

  PaymentSettingsModel({
    required this.error,
    required this.message,
    required this.data,
  });

  factory PaymentSettingsModel.fromJson(Map<String, dynamic> json) {
    return PaymentSettingsModel(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? Data.fromJson(json['data']) : Data(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  PaymentInfo stripe;
  PaymentInfo razorpay;

  Data({
    PaymentInfo? stripe,
    PaymentInfo? razorpay,
  })  : stripe = stripe ?? PaymentInfo(),
        razorpay = razorpay ?? PaymentInfo();

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      stripe: json['stripe'] != null ? PaymentInfo.fromJson(json['stripe']) : PaymentInfo(),
      razorpay: json['razorpay'] != null ? PaymentInfo.fromJson(json['razorpay']) : PaymentInfo(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stripe': stripe.toJson(),
      'razorpay': razorpay.toJson(),
    };
  }
}

class PaymentInfo {
  String gateway;
  String currency;
  String currencySymbol;
  bool status;
  String secretKey;
  String publishableKey;
  String webhookSecretKey;
  String webhookUrl;

  PaymentInfo({
    this.gateway = '',
    this.currency = '',
    this.currencySymbol = '',
    this.status = false,
    this.secretKey = '',
    this.publishableKey = '',
    this.webhookSecretKey = '',
    this.webhookUrl = '',
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      gateway: json['gateway'] ?? '',
      currency: json['currency'] ?? '',
      currencySymbol: json['currency_symbol'] ?? '',
      status: json['status'] ?? false,
      secretKey: json['secret_key'] ?? '',
      publishableKey: json['publishable_key'] ?? '',
      webhookSecretKey: json['webhook_secret_key'] ?? '',
      webhookUrl: json['webhook_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gateway': gateway,
      'currency': currency,
      'currency_symbol': currencySymbol,
      'status': status,
      'secret_key': secretKey,
      'publishable_key': publishableKey,
      'webhook_secret_key': webhookSecretKey,
      'webhook_url': webhookUrl,
    };
  }
}
