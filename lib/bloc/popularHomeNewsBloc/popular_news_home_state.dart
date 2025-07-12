
 import 'package:equatable/equatable.dart';

import '../../Model/popular_news_home_model.dart';


 abstract class PopularState extends Equatable{
   @override
    List<Object?> get props => [];
 }


 class PopularInitialState extends PopularState{}

 class PopularLoadingState extends PopularState{}



 class PopularSuccessState extends PopularState {
   final List<PopularHomeResponse> popularNews;

   PopularSuccessState({required this.popularNews});

   @override
   List<Object?> get props => [popularNews];


   PopularSuccessState copyWith({
     List<PopularHomeResponse>? popularNews,
   }) {
     return PopularSuccessState(
       popularNews: popularNews ?? this.popularNews,
     );
   }
 }


 class PopularErrorState extends PopularState{
   final String errorMessage;

   PopularErrorState({required this.errorMessage});

   @override
   List<Object?> get props => [errorMessage];
 }