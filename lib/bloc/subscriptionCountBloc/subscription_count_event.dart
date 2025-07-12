

import 'package:equatable/equatable.dart';

abstract class SubscriptionCountEvent extends Equatable {

  @override
  List<Object?> get props => [];
}


class PostSubscriptionCount extends SubscriptionCountEvent{
  final String countType;

  PostSubscriptionCount({required this.countType});

  @override
  List<Object?> get props => [countType];

}