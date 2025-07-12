import 'package:equatable/equatable.dart';

import '../../Model/channel_model.dart';

abstract class ChannelState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChannelInitialState extends ChannelState {}

class ChannelLoadingState extends ChannelState {

}

class ChannelSuccessState extends ChannelState {
  final List<ChannelResponse> channels;

  ChannelSuccessState(this.channels);

  @override
  List<Object?> get props => [channels];
}

class ChannelErrorState extends ChannelState {
  final String errorMessage;

  ChannelErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
