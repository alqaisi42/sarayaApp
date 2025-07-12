import 'package:equatable/equatable.dart';

import '../../Model/news_topic_model.dart';

abstract class NewstopicState extends Equatable{
  @override
  List<Object?> get props => [];
}

class NewstopicInitialState extends NewstopicState{}

class NewstopicLoadingState extends NewstopicState{}

class NewstopicSuccessState extends NewstopicState{
  final List<NewsTopicResponse> newsTopic;

  NewstopicSuccessState({required this.newsTopic});

  @override
  List<Object?> get props => [newsTopic];
}

class NewstopicErrorState extends NewstopicState{
  final String errorMessage;

  NewstopicErrorState(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}

