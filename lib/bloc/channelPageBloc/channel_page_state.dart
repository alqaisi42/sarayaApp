import 'package:equatable/equatable.dart';

import '../../Model/channel_page_model.dart';

abstract class ChannelPageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChannelPageInitialState extends ChannelPageState {}

class ChannelPageLoadingState extends ChannelPageState {}

class ChannelPageSuccessState extends ChannelPageState {
  final List<ChannelPageResponse> channelsPage;

  ChannelPageSuccessState(this.channelsPage);

  @override
  List<Object?> get props => [channelsPage];
}

class ChannelPageErrorState extends ChannelPageState {
  final String errorMessage;

  ChannelPageErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
