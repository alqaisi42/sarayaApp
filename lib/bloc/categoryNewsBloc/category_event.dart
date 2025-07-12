
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchCategoryContent extends CategoryEvent {
  final bool refreshIndicator;
  final int initialValue;
  final String category;
  final BuildContext context;

  const FetchCategoryContent( {this.refreshIndicator = false, this.initialValue = 1,this.category = "",required this.context});

  @override
  List<Object?> get props => [refreshIndicator, initialValue,category];
}

class FetchMoreCategoryContent extends CategoryEvent {}

class UpdateFavoriteStatusCategory extends CategoryEvent {
  final int itemId;
  final int status;

  const UpdateFavoriteStatusCategory({required this.itemId, required this.status});

  @override
  List<Object> get props => [itemId,status];
}
