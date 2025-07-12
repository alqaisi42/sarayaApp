import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ChannelsPreferenceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchChannelsPreference extends ChannelsPreferenceEvent {
  final bool refreshIndicator;
  final bool reFetch;
  final bool isShowLoading;
  final BuildContext? context;

  FetchChannelsPreference({this.refreshIndicator = false, this.reFetch = false, this.isShowLoading = true, this.context});

  @override
  List<Object?> get props => [refreshIndicator];
}

class ClearChannelsPreferenceData extends ChannelsPreferenceEvent {
  @override
  List<Object?> get props => [];
}
