
 import 'package:equatable/equatable.dart';

import '../../Model/recommendation_model.dart';


 abstract class RecommendationState extends Equatable{
   @override
    List<Object?> get props => [];
 }


 class RecommendationInitialState extends RecommendationState{}

 class RecommendationLoadingState extends RecommendationState{

   @override
   List<Object> get props => [];
 }



 class RecommendationSuccessState extends RecommendationState{
   final List<RecommedationResponse> recommendationNews;


   RecommendationSuccessState({required this.recommendationNews,});

   @override
   List<Object?> get props => [recommendationNews];
 }

 class RecommendationErrorState extends RecommendationState{
   final String errorMessage;

   RecommendationErrorState({required this.errorMessage});

   @override
   List<Object?> get props => [errorMessage];
 }