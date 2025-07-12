
 import 'package:equatable/equatable.dart';


import '../../Model/user_channel_follow_list.dart';




 abstract class UserChannelfollowState extends Equatable {
   @override
   List<Object?> get props => [];
 }

 class UserChannelfollowInitialState extends UserChannelfollowState {}

 class UserChannelfollowLoadingState extends UserChannelfollowState {
   final List<UserChannelFollowedListResponse> userChannelFollowList;

   UserChannelfollowLoadingState(this.userChannelFollowList);

   @override
   List<Object?> get props => [userChannelFollowList];
 }

 class UserChannelfollowLoadingMoreState extends UserChannelfollowState {
   final List<UserChannelFollowedListResponse> userChannelFollowList;

   UserChannelfollowLoadingMoreState(this.userChannelFollowList);

   @override
   List<Object?> get props => [userChannelFollowList];
 }

 class UserChannelfollowSuccessState extends UserChannelfollowState {
   final List<UserChannelFollowedListResponse> userChannelFollowList;

   UserChannelfollowSuccessState({required this.userChannelFollowList});

   @override
   List<Object?> get props => [userChannelFollowList];
 }

 class UserChannelfollowErrorState extends UserChannelfollowState {
   final String errorMessage;

   UserChannelfollowErrorState({required this.errorMessage});

   @override
   List<Object?> get props => [errorMessage];
 }