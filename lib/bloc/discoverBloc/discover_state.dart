
import 'package:equatable/equatable.dart';

import '../../Model/discover_model.dart';

abstract class DiscoverState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiscoverNewsInitialState extends DiscoverState {}


class DiscoverNewsLoadingState extends DiscoverState {
  @override
  List<Object?> get props => [];
}

class DiscoverNewsSuccessState extends DiscoverState {
  final List<DiscoverResponse> discoverNews;
  final bool hasMoreData;

  DiscoverNewsSuccessState({required this.discoverNews, required this.hasMoreData,
  });

  @override
  List<Object?> get props => [discoverNews,hasMoreData];
}

class DiscoverNewsLoadingMoreState extends DiscoverState {
  final List<DiscoverResponse> discoverNews;
  DiscoverNewsLoadingMoreState({required this.discoverNews});

  @override
  List<Object?> get props => [discoverNews];
}


class DiscoverNewsErrorState extends DiscoverState {
  final String errorMessage;

  DiscoverNewsErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}



