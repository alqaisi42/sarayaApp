import 'package:equatable/equatable.dart';

import '../../Model/multi_langauge_model.dart';

abstract class MultiLangState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MultiLangInitialState extends MultiLangState {}

class MultiLangLoadingState extends MultiLangState {}

class MultiLangSuccessState extends MultiLangState {
  final List<MultiLanguageModel> multiLangData;

  MultiLangSuccessState({required this.multiLangData});

  @override
  List<Object?> get props => [multiLangData];
}

class MultiLangErrorState extends MultiLangState {
  final String errorMessage;

  MultiLangErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}




