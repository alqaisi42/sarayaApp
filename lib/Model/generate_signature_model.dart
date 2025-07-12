class GenerateSignatureModel {
  String status;
  Data data;
  String message;

  GenerateSignatureModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory GenerateSignatureModel.fromJson(Map<String, dynamic> json) {
    return GenerateSignatureModel(
      status: json['status'] ?? '',
      data: json['data'] != null ? Data.fromJson(json['data']) : Data(),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class Data {
  String keyId;
  String orderId;
  String amount;
  String currency;
  String planId;
  String tenureId;
  String signature;
  String transactionId;

  Data({
    this.keyId = '',
    this.orderId = '',
    this.amount = '',
    this.currency = '',
    this.planId = '',
    this.tenureId = '',
    this.signature = '',
    this.transactionId = '',
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      keyId: json['key_id'] ?? '',
      orderId: json['order_id'] ?? '',
      amount: json['amount'] ?? '',
      currency: json['currency'] ?? '',
      planId: json['plan_id'] ?? '',
      tenureId: json['tenure_id'] ?? '',
      signature: json['signature'] ?? '',
      transactionId: json['transaction_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key_id': keyId,
      'order_id': orderId,
      'amount': amount,
      'currency': currency,
      'plan_id': planId,
      'tenure_id': tenureId,
      'signature': signature,
      'transaction_id': transactionId,
    };
  }
}
