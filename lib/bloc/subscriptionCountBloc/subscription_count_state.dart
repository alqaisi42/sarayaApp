


import 'package:equatable/equatable.dart';

import '../../Model/subscription_counts_model.dart';

abstract class SubscriptionCountState extends Equatable {
  const SubscriptionCountState();

  @override
  List<Object?> get props => [];
}

class SubscriptionCountInitial extends SubscriptionCountState {}

class SubscriptionCountLoading extends SubscriptionCountState {}

class SubscriptionCountLoaded extends SubscriptionCountState {
  final List<SubscriptionCountsModel> subscriptionCountData;

  const SubscriptionCountLoaded({required this.subscriptionCountData});

  @override
  List<Object?> get props => [subscriptionCountData];
}

class SubscriptionCountError extends SubscriptionCountState {
  final String errorMessage;

  const SubscriptionCountError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}