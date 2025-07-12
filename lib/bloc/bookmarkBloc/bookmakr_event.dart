
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object?> get props => [];
}

class FetchBookmark extends BookmarkEvent {

  final bool refreshIndicator;
  final int initialValue;
  final BuildContext context;

  const FetchBookmark({ this.refreshIndicator = false,this.initialValue = 1, required this.context});

  @override
  List<Object?> get props => [refreshIndicator,context];
}


class FetchMoreBookmark extends BookmarkEvent {
  final BuildContext context;

  const FetchMoreBookmark({required this.context});

  @override
  List<Object?> get props => [context];
}


