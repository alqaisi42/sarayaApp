
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class PopularNewsAllEvent extends Equatable {
  const PopularNewsAllEvent();

  @override
  List<Object?> get props => [];
}

class FetchPopularNewsAll extends PopularNewsAllEvent {

  final BuildContext context;

  final bool refreshIndicator;
  final int initialValue;

  const FetchPopularNewsAll({ this.refreshIndicator = false, required this.context, this.initialValue = 1});

  @override
  List<Object?> get props => [refreshIndicator];
}

class FetchMorePopularNewsAll extends PopularNewsAllEvent {
  final BuildContext context;
  const FetchMorePopularNewsAll({required this.context});

  @override
  List<Object?> get props => [context];
}

