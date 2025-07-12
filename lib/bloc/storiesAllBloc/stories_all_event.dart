import 'package:equatable/equatable.dart';

abstract class StoriesAllEvent extends Equatable{}

class FetchStoriesAllTopic extends StoriesAllEvent{
  final String storiesTopic;

  FetchStoriesAllTopic({required this.storiesTopic});

  @override
  List<Object?> get props => [storiesTopic];
}

class FetchStoriesAllMoreTopics extends StoriesAllEvent {

  @override
  List<Object?> get props => [];
}