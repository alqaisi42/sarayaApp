class VerifyPaymentModel {
  String? status;
  String? message;
  Errors? errors;

  VerifyPaymentModel({this.status, this.message, this.errors});

  VerifyPaymentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? '';
    message = json['message'] ?? '';
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : Errors();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status ?? '';
    data['message'] = message ?? '';
    data['errors'] = errors?.toJson() ?? Errors().toJson();
    return data;
  }
}

class Errors {
  List<String> razorpayPaymentId;
  List<String> razorpayOrderId;
  List<String> razorpaySignature;
  List<String> planId;
  List<String> tenureId;
  List<String> amount;

  Errors({
    this.razorpayPaymentId = const [],
    this.razorpayOrderId = const [],
    this.razorpaySignature = const [],
    this.planId = const [],
    this.tenureId = const [],
    this.amount = const [],
  });

  Errors.fromJson(Map<String, dynamic> json)
      : razorpayPaymentId = List<String>.from(json['razorpay_payment_id'] ?? []),
        razorpayOrderId = List<String>.from(json['razorpay_order_id'] ?? []),
        razorpaySignature = List<String>.from(json['razorpay_signature'] ?? []),
        planId = List<String>.from(json['plan_id'] ?? []),
        tenureId = List<String>.from(json['tenure_id'] ?? []),
        amount = List<String>.from(json['amount'] ?? []);

  Map<String, dynamic> toJson() {
    return {
      'razorpay_payment_id': razorpayPaymentId,
      'razorpay_order_id': razorpayOrderId,
      'razorpay_signature': razorpaySignature,
      'plan_id': planId,
      'tenure_id': tenureId,
      'amount': amount,
    };
  }
}
