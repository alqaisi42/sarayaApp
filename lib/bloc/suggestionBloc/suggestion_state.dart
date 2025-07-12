


import 'package:equatable/equatable.dart';

import '../../Model/suggestion_model.dart';

abstract class SuggestionState extends Equatable{
  @override
  List<Object?> get props => [];
}

class SuggestionInitialState extends SuggestionState{}

class SuggestionLoadingState extends SuggestionState{}

class SuggestionSuccessState extends SuggestionState{
  final List<SuggestionResponse> suggestion;

  SuggestionSuccessState({required this.suggestion});

  @override
  List<Object?> get props => [suggestion];
}

class SuggestionErrorState extends SuggestionState{
  final String errorMessage;

  SuggestionErrorState(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
