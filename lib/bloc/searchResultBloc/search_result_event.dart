
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SearchResultEvent extends Equatable{

  @override
  List<Object> get props => [];
}

class FetchSearchResult extends SearchResultEvent{
final String suggestionText;
final BuildContext context;

FetchSearchResult({required this.suggestionText,required this.context});
  @override
  List<Object> get props => [suggestionText];
}

class FetchMoreSearchResult extends SearchResultEvent {
  final BuildContext context;

  FetchMoreSearchResult({required this.context});

  @override
  List<Object> get props => [context];
}

class EmptySearchResult extends SearchResultEvent {}