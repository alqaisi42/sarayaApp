import 'package:equatable/equatable.dart';

abstract class StoriesEvent extends Equatable{}

class FetchStories extends StoriesEvent{
  final bool refreshIndicator;
  final bool reFetch;

  FetchStories({this.refreshIndicator = false,this.reFetch = false});


  @override
  List<Object?> get props => [];
}

