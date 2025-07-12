

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';


import '../../Model/news_topic_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/get_api_repo.dart';
import 'news_topic_event.dart';
import 'news_topic_state.dart';

class NewsTopicBloc extends Bloc<NewsTopicEvent,NewstopicState>{
    List<NewsTopicResponse>? cachedNewsTopic;
  
    NewsTopicBloc() : super(NewstopicInitialState()){
    on<FetchNewsTopic>(onFetchNewsTopic);
  }
  
  Future<void> onFetchNewsTopic(FetchNewsTopic event, Emitter<NewstopicState> emit) async {
      if(event.refreshIndicator || cachedNewsTopic == null){
        emit(NewstopicLoadingState());
        try{
          final apiRepo = GetapiRepo(url: newsTopicUrl, fromJson: NewsTopicResponse.fromJson, isToken: false);

          final List<NewsTopicResponse> newsTopicData = await apiRepo.getData();
          cachedNewsTopic = newsTopicData;

          emit(NewstopicSuccessState(newsTopic: newsTopicData));
        }catch(e){
          log(e.toString());
        }
      } else {
        emit(NewstopicSuccessState(newsTopic: cachedNewsTopic! ));
      }
  }
}