import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ChannelPageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchChannelPage extends ChannelPageEvent {
  final bool refreshIndicator;
  final String channelSlug;
  final BuildContext context;


  FetchChannelPage(this.channelSlug,  {this.refreshIndicator = false,required this.context});

  @override
  List<Object?> get props => [refreshIndicator];
}

