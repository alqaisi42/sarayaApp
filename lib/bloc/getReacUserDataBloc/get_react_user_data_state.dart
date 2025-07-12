import 'package:equatable/equatable.dart';

import '../../Model/reactors_user_model.dart';

abstract class GetReactUserDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetReactUserDataInitialState extends GetReactUserDataState {}

class GetReactUserDataLoadingState extends GetReactUserDataState {
  final List<ReactorsUserModel> reactorsDataList;

  GetReactUserDataLoadingState(this.reactorsDataList);

  @override
  List<Object?> get props => [reactorsDataList];
}

class GetReactUserDataLoadingMoreState extends GetReactUserDataState {
  final List<ReactorsUserModel> reactorsDataList;

  GetReactUserDataLoadingMoreState(this.reactorsDataList);

  @override
  List<Object?> get props => [reactorsDataList];
}

class GetReactUserDataSuccessState extends GetReactUserDataState {
  final List<ReactorsUserModel> reactorsDataList;

  GetReactUserDataSuccessState({required this.reactorsDataList});

  @override
  List<Object?> get props => [reactorsDataList];
}

class GetReactUserDataErrorState extends GetReactUserDataState {
  final String errorMessage;

  GetReactUserDataErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

