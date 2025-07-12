import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FollowedChannelsPostEvent extends Equatable {
  const FollowedChannelsPostEvent();

  @override
  List<Object?> get props => [];
}

class FetchFollowedChannelsPost extends FollowedChannelsPostEvent {
  final BuildContext context;
  final bool refreshIndicator;
  final int initialValue;



  const FetchFollowedChannelsPost({
    this.refreshIndicator = false,
    required this.context,
    this.initialValue = 1,

  });

  @override
  List<Object?> get props => [refreshIndicator];
}

class FetchMoreFollowedChannelsPost extends FollowedChannelsPostEvent {
  final BuildContext context;


  const FetchMoreFollowedChannelsPost({required this.context});

  @override
  List<Object?> get props => [context];
}
