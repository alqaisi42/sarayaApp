import 'package:equatable/equatable.dart';


import '../../Model/stories_model.dart';

abstract class StoriesAllState extends Equatable{
  @override
  List<Object?> get props => [];
}

class StoriesAllTopicsInitialState extends StoriesAllState{}

class StoriesAllTopicsLoadingState extends StoriesAllState{
  final List<StoryResponse> storiesall;

  StoriesAllTopicsLoadingState({required this.storiesall});

  @override
  List<Object?> get props => [storiesall];
}

class StoriesAllTopicsLoadingMoreState extends StoriesAllState {
  final List<StoryResponse> storiesall;

  StoriesAllTopicsLoadingMoreState({required this.storiesall});

  @override
  List<Object?> get props => [storiesall];
}

class StoriesAllTopicsSuccessState extends StoriesAllState {
  final List<StoryResponse> storiesall;


  StoriesAllTopicsSuccessState({
    required this.storiesall,

  });

  @override
  List<Object?> get props => [storiesall];
}



class StoriesAllTopicsErrorState extends StoriesAllState{
  final String errorMessage;

  StoriesAllTopicsErrorState(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}


