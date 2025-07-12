import 'package:equatable/equatable.dart';

import '../../Model/channel_model.dart';

abstract class ChannelsPreferenceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChannelsPreferenceInitialState extends ChannelsPreferenceState {}

class ChannelsPreferenceLoadingState extends ChannelsPreferenceState {}

class ChannelsPreferenceSuccessState extends ChannelsPreferenceState {
  final List<ChannelResponse> channels;

  ChannelsPreferenceSuccessState(this.channels);

  @override
  List<Object?> get props => [channels];
}

class ChannelsPreferenceErrorState extends ChannelsPreferenceState {
  final String errorMessage;

  ChannelsPreferenceErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
