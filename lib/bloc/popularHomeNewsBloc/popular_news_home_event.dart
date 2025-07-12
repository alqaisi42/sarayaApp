
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class PopularEvent extends Equatable{}

class FetchPopular extends PopularEvent{
  final bool refreshIndicator;
  final bool reFetch;
  final BuildContext? context;

  FetchPopular({this.refreshIndicator = false,this.reFetch = false,this.context});
  @override
  List<Object> get props => [];
}

class ClearPopularsData extends PopularEvent {
  @override
  List<Object?> get props => [];
}

class UpdateFavoriteStatus extends PopularEvent {
  final int itemId;
  final int status;

  UpdateFavoriteStatus({required this.itemId, required this.status});

  @override
  List<Object> get props => [];
}