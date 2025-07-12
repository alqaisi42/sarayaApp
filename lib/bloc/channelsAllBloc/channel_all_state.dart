
 import 'package:equatable/equatable.dart';

import '../../Model/channel_response.dart';





 abstract class ChannelsAllState extends Equatable {
   @override
   List<Object?> get props => [];
 }

 class ChannelsAllInitialState extends ChannelsAllState {}

 class ChannelsAllLoadingState extends ChannelsAllState {
   final List<ChannelAllResponse> channelsAll;

   ChannelsAllLoadingState(this.channelsAll);

   @override
   List<Object?> get props => [channelsAll];
 }

 class ChannelsAllLoadingMoreState extends ChannelsAllState {
   final List<ChannelAllResponse> channelsAll;

   ChannelsAllLoadingMoreState(this.channelsAll);

   @override
   List<Object?> get props => [channelsAll];
 }

 class ChannelsAllSuccessState extends ChannelsAllState {
   final List<ChannelAllResponse> channelsAll;

   ChannelsAllSuccessState({required this.channelsAll});

   @override
   List<Object?> get props => [channelsAll];
 }

 class ChannelsAllErrorState extends ChannelsAllState {
   final String errorMessage;

   ChannelsAllErrorState({required this.errorMessage});

   @override
   List<Object?> get props => [errorMessage];
 }
