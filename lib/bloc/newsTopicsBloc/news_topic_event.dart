import 'package:equatable/equatable.dart';

abstract class NewsTopicEvent extends Equatable{}

class FetchNewsTopic extends NewsTopicEvent{
  final bool refreshIndicator;

  FetchNewsTopic({this.refreshIndicator = false});

  @override
  List<Object> get props => [];
}