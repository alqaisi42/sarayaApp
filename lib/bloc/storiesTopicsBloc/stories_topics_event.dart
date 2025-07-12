import 'package:equatable/equatable.dart';

abstract class StoriesTopicsEvent extends Equatable{}

class FetchStoriesTopics extends StoriesTopicsEvent{
  @override
  List<Object?> get props => [];
}

class FetchStoriesMoreTopics extends StoriesTopicsEvent {

  @override
  List<Object?> get props => [];
}