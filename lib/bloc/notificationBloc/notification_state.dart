
 import 'package:equatable/equatable.dart';
import '../../Model/notification_model.dart';






 abstract class NotificationState extends Equatable {
   @override
   List<Object?> get props => [];
 }

 class NotificationInitialState extends NotificationState {}

 class NotificationLoadingState extends NotificationState {
   final List<NotificationModel> notificationData;

   NotificationLoadingState(this.notificationData);

   @override
   List<Object?> get props => [notificationData];
 }

 class NotificationLoadingMoreState extends NotificationState {
   final List<NotificationModel> notificationData;

   NotificationLoadingMoreState(this.notificationData);

   @override
   List<Object?> get props => [notificationData];
 }

 class NotificationSuccessState extends NotificationState {
   final List<NotificationModel> notificationData;

   NotificationSuccessState({required this.notificationData});

   @override
   List<Object?> get props => [notificationData];
 }

 class NotificationErrorState extends NotificationState {
   final String errorMessage;

   NotificationErrorState({required this.errorMessage});

   @override
   List<Object?> get props => [errorMessage];
 }
