
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ChannelAllEvent extends Equatable {
  const ChannelAllEvent();

  @override
  List<Object?> get props => [];
}

class FetchChannelAll extends ChannelAllEvent {
  final bool refreshIndicator;
  final int initialValue;
  final BuildContext context;

  const FetchChannelAll({this.refreshIndicator = false, this.initialValue = 1, required this.context});

  @override
  List<Object?> get props => [refreshIndicator, initialValue,context];
}

class FetchMoreChannelAll extends ChannelAllEvent {
  final BuildContext context;

  const FetchMoreChannelAll({required this.context});

  @override
  List<Object?> get props => [context];
}

