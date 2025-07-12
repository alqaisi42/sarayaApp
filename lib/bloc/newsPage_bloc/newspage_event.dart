
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class NewsPageEvent extends Equatable {
  const NewsPageEvent();

  @override
  List<Object?> get props => [];
}

class FetchNewsPagesData extends NewsPageEvent {
  final bool refreshIndicator;
  final int initialValue;
  final String channelSlug;
  final String sortValue;
  final String channelCategory;
  final BuildContext context;
  const FetchNewsPagesData({ this.refreshIndicator = false,this.initialValue = 1,this.channelSlug = "", this.sortValue = "all", this.channelCategory = "all",required this.context});

  @override
  List<Object?> get props => [refreshIndicator];
}

class FetchMoreFetchNewsPagesData extends NewsPageEvent {}

