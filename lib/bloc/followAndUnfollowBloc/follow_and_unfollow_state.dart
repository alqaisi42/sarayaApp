import 'package:equatable/equatable.dart';

import '../../Model/follow_and_unfollow_model.dart';

abstract class FollowAndunfollowState extends Equatable{
  @override
  List<Object?> get props => [];
}


class FollowAndunfollowInitialState extends FollowAndunfollowState{}

class FollowAndunfollowLoadingState extends FollowAndunfollowState{}

class FollowAndunfollowSuccessState extends FollowAndunfollowState{
 final List<FollowAndUnfollowResponse> followAndFollowData;


  FollowAndunfollowSuccessState({required this.followAndFollowData});
}

class FollowAndunfollowErrorState extends FollowAndunfollowState{
  final String errorMessage;

  FollowAndunfollowErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

