import 'package:equatable/equatable.dart';

import '../../Model/recommendation_model.dart';

abstract class RecommendationAllState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RecommendationAllInitialState extends RecommendationAllState {}

class RecommendationAllLoadingState extends RecommendationAllState {
  final List<RecommedationResponse> recommendations;

  RecommendationAllLoadingState(this.recommendations);

  @override
  List<Object?> get props => [recommendations];
}

class RecommendationAllLoadingMoreState extends RecommendationAllState {
  final List<RecommedationResponse> recommendations;

  RecommendationAllLoadingMoreState(this.recommendations);

  @override
  List<Object?> get props => [recommendations];
}

class RecommendationAllSuccessState extends RecommendationAllState {
  final List<RecommedationResponse> recommendations;

  RecommendationAllSuccessState({required this.recommendations});

  @override
  List<Object?> get props => [recommendations];
}

class RecommendationAllErrorState extends RecommendationAllState {
  final String errorMessage;

  RecommendationAllErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
