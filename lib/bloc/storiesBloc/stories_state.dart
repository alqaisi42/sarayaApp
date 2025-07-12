import 'package:equatable/equatable.dart';


import '../../Model/stories_model.dart';

abstract class StoriesState extends Equatable{
  @override
  List<Object?> get props => [];
}

class StoriesInitialState extends StoriesState{}

class StoriesLoadingState extends StoriesState{}

class StoriesSuccessState extends StoriesState{
final List<StoryResponse> storiesData;

StoriesSuccessState({required this.storiesData});

@override
  List<Object?> get props => [storiesData];
}

class StoriesErrorState extends StoriesState{
  final String errorMessage;

  StoriesErrorState(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}


