


import 'package:equatable/equatable.dart';


import '../../Model/multi_lang_post_model.dart';

abstract class MultiNewsPostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MultiNewsPostInitialState extends MultiNewsPostState {}

class MultiNewsPostLoadingState extends MultiNewsPostState {}

class MultiNewsPostSuccessState extends MultiNewsPostState {
  final List<MultiLangPostModel> newsLanguageIdData;

  MultiNewsPostSuccessState({required this.newsLanguageIdData});

  @override
  List<Object?> get props => [newsLanguageIdData];
}

class MultiNewsPostErrorState extends MultiNewsPostState {
  final String errorMessage;

  MultiNewsPostErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
