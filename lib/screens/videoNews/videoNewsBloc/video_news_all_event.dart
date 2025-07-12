
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class VideoNewsEvent extends Equatable {
  const VideoNewsEvent();

  @override
  List<Object?> get props => [];
}

class FetchVideoNews extends VideoNewsEvent {
  final BuildContext context;
  final bool refreshIndicator;
  final int initialValue;

  const FetchVideoNews({ this.refreshIndicator = false, required this.context, this.initialValue = 1 });

  @override
  List<Object?> get props => [refreshIndicator];
}

class FetchMoreVideoNews extends VideoNewsEvent {
  final BuildContext context;

  const FetchMoreVideoNews({required this.context});

  @override
  List<Object?> get props => [context];
}

