


class MembershipPlansModel {
  final bool error;
  final Data data;
  final String message;

  MembershipPlansModel({
    this.error = false,
    Data? data,
    this.message = '',
  }) : data = data ?? Data();

  factory MembershipPlansModel.fromJson(Map<String, dynamic> json) {
    return MembershipPlansModel(
      error: json['error'] ?? false,
      data: Data.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class Data {
  final List<Plans> plans;
  final ActiveSubscription activeSubscription;
  final List<Transactions> transactions;
  final String currency;
  final String currencySymbol;
  final String endDate;

  Data({
    this.plans = const [],
    ActiveSubscription? activeSubscription,
    this.transactions = const [],
    this.currency = '',
    this.currencySymbol = '',
    this.endDate = '',
  }) : activeSubscription = activeSubscription ?? ActiveSubscription();

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      plans: (json['plans'] as List?)?.map((e) => Plans.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      activeSubscription: ActiveSubscription.fromJson(json['active_subscription'] ?? {}),
      transactions: (json['transactions'] as List?)?.map((e) => Transactions.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      currency: json['currency']?.toString() ?? '',
      currencySymbol: json['currency_symbol']?.toString() ?? '',
      endDate: json['lastSubscriptionEndDate']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plans': plans.map((e) => e.toJson()).toList(),
      'active_subscription': activeSubscription.toJson(),
      'transactions': transactions.map((e) => e.toJson()).toList(),
      'currency': currency,
      'currency_symbol': currencySymbol,
      'lastSubscriptionEndDate': endDate,
    };
  }
}

class Plans {
  final int id;
  final String name;
  final String description;
  final String slug;
  final bool status;
  final String createdAt;
  final String updatedAt;
  final bool isActivePlan;
  final List<Features> features;
  final List<PlanTenures> planTenures;

  Plans({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.slug = '',
    this.status = false,
    this.createdAt = '',
    this.updatedAt = '',
    this.isActivePlan = false,
    this.features = const [],
    this.planTenures = const [],
  });

  factory Plans.fromJson(Map<String, dynamic> json) {
    return Plans(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      status: json['status'] ?? false,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      isActivePlan: json['is_active_plan'] ?? false,
      features: (json['features'] as List?)?.map((e) => Features.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      planTenures: (json['plan_tenures'] as List?)?.map((e) => PlanTenures.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'slug': slug,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_active_plan': isActivePlan,
      'features': features.map((e) => e.toJson()).toList(),
      'plan_tenures': planTenures.map((e) => e.toJson()).toList(),
    };
  }
}

class Features {
  final int id;
  final int planId;
  final bool isAdsFree;
  final int numberOfArticles;
  final int numberOfStories;
  final String createdAt;
  final String updatedAt;

  Features({
    this.id = 0,
    this.planId = 0,
    this.isAdsFree = false,
    this.numberOfArticles = 0,
    this.numberOfStories = 0,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      id: json['id'] ?? 0,
      planId: json['plan_id'] ?? 0,
      isAdsFree: json['is_ads_free'] ?? false,
      numberOfArticles: json['number_of_articles'] ?? 0,
      numberOfStories: json['number_of_stories'] ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'is_ads_free': isAdsFree,
      'number_of_articles': numberOfArticles,
      'number_of_stories': numberOfStories,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PlanTenures {
  final int id;
  final String name;
  final int planId;
  final int duration;
  final String price;
  final String discountPrice;
  final String startDate;
  final String endDate;
  final String createdAt;
  final String updatedAt;

  PlanTenures({
    this.id = 0,
    this.name = '',
    this.planId = 0,
    this.duration = 0,
    this.price = '',
    this.discountPrice = '',
    this.startDate = '',
    this.endDate = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory PlanTenures.fromJson(Map<String, dynamic> json) {
    return PlanTenures(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      planId: json['plan_id'] ?? 0,
      duration: json['duration'] ?? 0,
      price: json['price']?.toString() ?? '',
      discountPrice: json['discount_price']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'plan_id': planId,
      'duration': duration,
      'price': price,
      'discount_price': discountPrice,
      'start_date': startDate,
      'end_date': endDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ActiveSubscription {
  final int duration;
  final int articleCount;
  final int storyCount;
  final int maxArticles;
  final int maxStories;
  final bool status;
  final String startDate;
  final String endDate;
  final int planId;
  final int tenureId;
  final int freeTrialPostLimit;
  final int freeTrialStoryLimit;
  final bool isAdsActive;
  final String planName;
  final int? totalCount; // Added to match the API response

  ActiveSubscription({
    this.duration = 0,
    this.status = false,
    this.startDate = '',
    this.endDate = '',
    this.planId = 0,
    this.tenureId = 0,
    this.freeTrialPostLimit = 0,
    this.freeTrialStoryLimit = 0,
    this.isAdsActive = false,
    this.planName = '',
    this.articleCount = 0,
    this.maxArticles = 0,
    this.maxStories = 0,
    this.storyCount = 0,
    this.totalCount = 0,
  });

  factory ActiveSubscription.fromJson(Map<String, dynamic> json) {
    return ActiveSubscription(
      duration: _parseIntSafely(json['duration']) ?? 0,
      planId: _parseIntSafely(json['plan_id']) ?? 0,
      tenureId: _parseIntSafely(json['tenure_id']) ?? 0,
      freeTrialPostLimit: _parseIntSafely(json['free_trial_post_limit']) ?? 0,
      freeTrialStoryLimit: _parseIntSafely(json['free_trial_story_limit']) ?? 0,
      articleCount: _parseIntSafely(json['article_count']) ?? 0,
      storyCount: _parseIntSafely(json['story_count']) ?? 0,
      totalCount: _parseIntSafely(json['total_count']),
      maxStories: _parseIntSafely(json['max_stories']) ?? 0,
      maxArticles: _parseIntSafely(json['max_articles']) ?? 0,
      status: json['status'] ?? false,
      isAdsActive: json['is_ads_Active'] ?? false,  // Fixed to match exact case in API: capital 'A'
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      planName: json['plan_name']?.toString() ?? '',
    );
  }

  static int? _parseIntSafely(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'plan_id': planId,
      'tenure_id': tenureId,
      'free_trial_post_limit': freeTrialPostLimit,
      'free_trial_story_limit': freeTrialStoryLimit,
      'is_ads_Active': isAdsActive,
      'plan_name': planName,
      'article_count': articleCount,
      'story_count': storyCount,
      'total_count': totalCount,
      'max_articles': maxArticles,
      'max_stories': maxStories,
    };
  }
}

class Transactions {
  final int id;
  final int userId;
  final dynamic orderId;
  final String transactionId;
  final String paymentGateway;
  final String amount;
  final String discount;
  final PlanDetails? planDetails;
  final String status;
  final String createdAt;
  final String updatedAt;

  Transactions({
    this.id = 0,
    this.userId = 0,
    this.orderId,
    this.transactionId = '',
    this.paymentGateway = '',
    this.amount = '',
    this.discount = '',
    this.planDetails,
    this.status = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      orderId: json['order_id'],
      transactionId: json['transaction_id']?.toString() ?? '',
      paymentGateway: json['payment_gateway']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      discount: json['discount']?.toString() ?? '',
      planDetails: json['plan_details'] != null
          ? PlanDetails.fromJson(json['plan_details'] as Map<String, dynamic>)
          : null,
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_id': orderId,
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
  final Plan? plan;
  final List<Features> features;
  final List<PlanTenures> tenures;

  PlanDetails({
    this.plan,
    this.features = const [],
    this.tenures = const [],
  });

  factory PlanDetails.fromJson(Map<String, dynamic> json) {
    return PlanDetails(
      plan: json['plan'] != null ? Plan.fromJson(json['plan'] as Map<String, dynamic>) : null,
      features: (json['features'] as List?)?.map((x) => Features.fromJson(x as Map<String, dynamic>)).toList() ?? [],
      tenures: (json['tenures'] as List?)?.map((x) => PlanTenures.fromJson(x as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan': plan?.toJson(),
      'features': features.map((x) => x.toJson()).toList(),
      'tenures': tenures.map((x) => x.toJson()).toList(),
    };
  }
}

class Plan {
  final int id;
  final String name;
  final String description;

  Plan({
    this.id = 0,
    this.name = '',
    this.description = '',
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
