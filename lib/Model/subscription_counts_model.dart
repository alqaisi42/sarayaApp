class SubscriptionCountsModel {
  bool error;
  String message;
  Data data;

  SubscriptionCountsModel({
    required this.error,
    required this.message,
    required this.data,
  });

  factory SubscriptionCountsModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionCountsModel(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? Data.fromJson(json['data']) : Data(subscription: Subscription.empty(), features: Features.empty()),
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
  Subscription subscription;
  Features features;

  Data({
    required this.subscription,
    required this.features,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'])
          : Subscription.empty(),
      features: json['features'] != null
          ? Features.fromJson(json['features'])
          : Features.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscription': subscription.toJson(),
      'features': features.toJson(),
    };
  }
}

class Subscription {
  int id;
  String transactionId;
  int userId;
  int planId;
  int planTenureId;
  int featureId;
  int duration;
  String status;
  String startDate;
  String endDate;
  String createdAt;
  String updatedAt;
  int articleCount;
  int storyCount;

  Subscription({
    required this.id,
    required this.transactionId,
    required this.userId,
    required this.planId,
    required this.planTenureId,
    required this.featureId,
    required this.duration,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.articleCount,
    required this.storyCount,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] ?? 0,
      transactionId: json['transaction_id'] ?? '',
      userId: json['user_id'] ?? 0,
      planId: json['plan_id'] ?? 0,
      planTenureId: json['plan_tenure_id'] ?? 0,
      featureId: json['feature_id'] ?? 0,
      duration: json['duration'] ?? 0,
      status: json['status'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      articleCount: json['article_count'] ?? 0,
      storyCount: json['story_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'user_id': userId,
      'plan_id': planId,
      'plan_tenure_id': planTenureId,
      'feature_id': featureId,
      'duration': duration,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'article_count': articleCount,
      'story_count': storyCount,
    };
  }

  factory Subscription.empty() {
    return Subscription(
      id: 0,
      transactionId: '',
      userId: 0,
      planId: 0,
      planTenureId: 0,
      featureId: 0,
      duration: 0,
      status: '',
      startDate: '',
      endDate: '',
      createdAt: '',
      updatedAt: '',
      articleCount: 0,
      storyCount: 0,
    );
  }
}

class Features {
  int maxArticles;
  int maxStories;

  Features({
    required this.maxArticles,
    required this.maxStories,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      maxArticles: json['max_articles'] ?? 0,
      maxStories: json['max_stories'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max_articles': maxArticles,
      'max_stories': maxStories,
    };
  }

  factory Features.empty() {
    return Features(
      maxArticles: 0,
      maxStories: 0,
    );
  }
}
