import 'package:equatable/equatable.dart';


import '../../Model/stories_model.dart';

abstract class StoriesTopicsState extends Equatable{
  @override
  List<Object?> get props => [];
}

class StoriesTopicsInitialState extends StoriesTopicsState{}

class StoriesTopicsLoadingState extends StoriesTopicsState{
  final List<StoryResponse> currentStories;

  StoriesTopicsLoadingState({required this.currentStories});

  @override
  List<Object?> get props => [currentStories];
}

class StoriesTopicsLoadingMoreState extends StoriesTopicsState {
  final List<StoryResponse> currentStories;

  StoriesTopicsLoadingMoreState({required this.currentStories});

  @override
  List<Object?> get props => [currentStories];
}

class StoriesTopicsSuccessState extends StoriesTopicsState {
  final List<StoryResponse> storiesTopicsData;


  StoriesTopicsSuccessState({
    required this.storiesTopicsData,

  });

  @override
  List<Object?> get props => [storiesTopicsData];
}



class StoriesTopicsErrorState extends StoriesTopicsState{
  final String errorMessage;

  StoriesTopicsErrorState(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}


