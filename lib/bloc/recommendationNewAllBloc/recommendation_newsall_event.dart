import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RecommendationAllEvent extends Equatable {
  const RecommendationAllEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecommendationAll extends RecommendationAllEvent {
  final BuildContext context;
  final bool refreshIndicator;
  final int initialValue;
  final String? getFollowedChannel;


  const FetchRecommendationAll({
    this.refreshIndicator = false,
    required this.context,
    this.initialValue = 1,
    this.getFollowedChannel = ""
  });

  @override
  List<Object?> get props => [refreshIndicator];
}

class FetchMoreRecommendationAll extends RecommendationAllEvent {
  final BuildContext context;
  final String? getFollowedChannel;

  const FetchMoreRecommendationAll({required this.context,this.getFollowedChannel = ""});

  @override
  List<Object?> get props => [context];
}
