
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class FetchNotification extends NotificationEvent {
  final BuildContext context;
  final bool refreshIndicator;
  final int initialValue;
  final String? fcmToken;

  const FetchNotification({
    this.refreshIndicator = false,
    required this.context,
    this.initialValue = 1,
    this.fcmToken
  });

  @override
  List<Object?> get props => [refreshIndicator, context, initialValue];
}

class FetchMoreNotification extends NotificationEvent {
  final BuildContext context;

  const FetchMoreNotification({required this.context});

  @override
  List<Object?> get props => [context];
}


