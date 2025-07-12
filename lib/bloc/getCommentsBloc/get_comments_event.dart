
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class GetCommentsEvent extends Equatable {
  const GetCommentsEvent();

  @override
  List<Object?> get props => [];
}

class FetchGetComments extends GetCommentsEvent {
  final dynamic getPostId;
  final BuildContext context;
  final String? slug;

  const FetchGetComments({
    required this.getPostId,
    required this.context,
    this.slug,
  });

  @override
  List<Object?> get props => [getPostId, context, slug];
}


class FetchMoreComments extends GetCommentsEvent {
  @override
  List<Object?> get props => [];
}

