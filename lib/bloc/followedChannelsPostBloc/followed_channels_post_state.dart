import 'package:equatable/equatable.dart';

import '../../Model/recommendation_model.dart';

abstract class FollowedChannelsPostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FollowedChannelsPostInitialState extends FollowedChannelsPostState {}

class FollowedChannelsPostLoadingState extends FollowedChannelsPostState {
  final List<RecommedationResponse> followedChannelPostData;

  FollowedChannelsPostLoadingState(this.followedChannelPostData);

  @override
  List<Object?> get props => [followedChannelPostData];
}

class FollowedChannelsPostLoadingMoreState extends FollowedChannelsPostState {
  final List<RecommedationResponse> followedChannelPostData;

  FollowedChannelsPostLoadingMoreState(this.followedChannelPostData);

  @override
  List<Object?> get props => [followedChannelPostData];
}

class FollowedChannelsPostSuccessState extends FollowedChannelsPostState {
  final List<RecommedationResponse> followedChannelPostData;
  final bool? hasMoreData;


  FollowedChannelsPostSuccessState({required this.followedChannelPostData, this.hasMoreData = true});

  @override
  List<Object?> get props => [followedChannelPostData,hasMoreData];
}

class FollowedChannelsPostErrorState extends FollowedChannelsPostState {
  final String errorMessage;

  FollowedChannelsPostErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
