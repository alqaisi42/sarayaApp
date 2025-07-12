import 'package:equatable/equatable.dart';

abstract class SuggestionEvent extends Equatable{}

class FetchSuggestion extends SuggestionEvent{
  final String suggestionVal;

  FetchSuggestion({required this.suggestionVal});

  @override
  List<Object?> get props => [];
}