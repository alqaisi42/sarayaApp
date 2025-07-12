
import 'package:equatable/equatable.dart';

abstract class NotificationReadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class InitializeNotificationRead extends NotificationReadEvent {
  final Map<String, int> initialData;

  InitializeNotificationRead({required this.initialData});

  @override
  List<Object?> get props => [initialData];
}

class UpdateNotificationRead extends NotificationReadEvent {
  final String slug;
  final bool isReadVal;

  UpdateNotificationRead({required this.slug, required this.isReadVal,});

  @override
  List<Object?> get props => [slug, isReadVal];
}