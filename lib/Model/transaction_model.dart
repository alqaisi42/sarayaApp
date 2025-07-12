class TransactionModel {
  bool? error;
  List<Data>? data;
  String? message;

  TransactionModel({this.error, this.data, this.message});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['data'] != null) {
      data = List<Data>.from(json['data'].map((v) => Data.fromJson(v)));
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'data': data?.map((v) => v.toJson()).toList(),
      'message': message,
    };
  }
}

class Data {
  int? id;
  int? userId;
  String? transactionId;
  String? paymentGateway;
  String? amount;
  String? discount;
  PlanDetails? planDetails;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.userId,
    this.transactionId,
    this.paymentGateway,
    this.amount,
    this.discount,
    this.planDetails,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    transactionId = json['transaction_id'];
    paymentGateway = json['payment_gateway'];
    amount = json['amount'];
    discount = json['discount'];
    planDetails = json['plan_details'] != null
        ? PlanDetails.fromJson(json['plan_details'])
        : null;
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'transaction_id': transactionId,
      'payment_gateway': paymentGateway,
      'amount': amount,
      'discount': discount,
      'plan_details': planDetails?.toJson(),
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PlanDetails {
  Plan? plan;
  List<Features>? features;
  List<Tenures>? tenures;
  List<dynamic>? subscriptions;

  PlanDetails({this.plan, this.features, this.tenures, this.subscriptions});

  PlanDetails.fromJson(Map<String, dynamic> json) {
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    if (json['features'] != null) {
      features = List<Features>.from(json['features'].map((v) => Features.fromJson(v)));
    }
    if (json['tenures'] != null) {
      tenures = List<Tenures>.from(json['tenures'].map((v) => Tenures.fromJson(v)));
    }
    if (json['subscriptions'] != null) {
      subscriptions = List<dynamic>.from(json['subscriptions']);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'plan': plan?.toJson(),
      'features': features?.map((v) => v.toJson()).toList(),
      'tenures': tenures?.map((v) => v.toJson()).toList(),
      'subscriptions': subscriptions,
    };
  }
}

class Plan {
  int? planId;
  String? planName;
  String? planDescription;
  String? planSlug;
  bool? planStatus;

  Plan({
    this.planId,
    this.planName,
    this.planDescription,
    this.planSlug,
    this.planStatus,
  });

  Plan.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    planName = json['plan_name'];
    planDescription = json['plan_description'];
    planSlug = json['plan_slug'];
    planStatus = json['plan_status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'plan_name': planName,
      'plan_description': planDescription,
      'plan_slug': planSlug,
      'plan_status': planStatus,
    };
  }
}

class Features {
  int? featureId;
  int? planId;
  bool? isAdsFree;
  int? numberOfArticles;
  int? numberOfStories;

  Features({
    this.featureId,
    this.planId,
    this.isAdsFree,
    this.numberOfArticles,
    this.numberOfStories,
  });

  Features.fromJson(Map<String, dynamic> json) {
    featureId = json['feature_id'];
    planId = json['plan_id'];
    isAdsFree = json['is_ads_free'];
    numberOfArticles = json['number_of_articles'];
    numberOfStories = json['number_of_stories'];
  }

  Map<String, dynamic> toJson() {
    return {
      'feature_id': featureId,
      'plan_id': planId,
      'is_ads_free': isAdsFree,
      'number_of_articles': numberOfArticles,
      'number_of_stories': numberOfStories,
    };
  }
}

class Tenures {
  int? tenureId;
  int? planId;
  String? tenureName;
  int? duration;
  String? price;
  String? discountPrice;
  String? startDate;
  String? endDate;

  Tenures({
    this.tenureId,
    this.planId,
    this.tenureName,
    this.duration,
    this.price,
    this.discountPrice,
    this.startDate,
    this.endDate,
  });

  Tenures.fromJson(Map<String, dynamic> json) {
    tenureId = json['tenure_id'];
    planId = json['plan_id'];
    tenureName = json['tenure_name'];
    duration = json['duration'];
    price = json['price'];
    discountPrice = json['discount_price'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    return {
      'tenure_id': tenureId,
      'plan_id': planId,
      'tenure_name': tenureName,
      'duration': duration,
      'price': price,
      'discount_price': discountPrice,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}
