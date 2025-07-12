import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ChannelEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchChannels extends ChannelEvent {
  final bool refreshIndicator;
  final bool reFetch;
  final bool isShowLoading;
  final BuildContext? context;

  FetchChannels( {this.refreshIndicator = false,this.reFetch = false,this.isShowLoading = true, this.context});

  @override
  List<Object?> get props => [refreshIndicator];
}

class ClearChannelsData extends ChannelEvent {
  @override
  List<Object?> get props => [];
}