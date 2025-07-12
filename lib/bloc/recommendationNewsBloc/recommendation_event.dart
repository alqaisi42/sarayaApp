
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RecommendationEvent extends Equatable{}


class FetchRecommendation extends RecommendationEvent {
  final bool refreshIndicator;
  final int isInitial;
  final bool reFetch;
  final BuildContext? context;
  final String? getFollowedChannel;

  FetchRecommendation({
    this.refreshIndicator = false,
    this.isInitial = 1,
    this.reFetch = false,
    this.context,
    this.getFollowedChannel = "",
  });

  @override
  List<Object?> get props => [refreshIndicator, isInitial, reFetch, context,getFollowedChannel];
}


class ClearRecommendation extends RecommendationEvent{
  @override
  List<Object?> get props => [];
}


class FetchMoreRecommendation extends RecommendationEvent {
final BuildContext context;


FetchMoreRecommendation({required this.context});

  @override
  List<Object> get props => [context];
}
