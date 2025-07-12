
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:newsapp/config/api_routes.dart';

import '../../Model/notification_model.dart';


import '../blocRepository/get_api_repo.dart';

import '../notificationReadBloc/notification_read_bloc.dart';
import '../notificationReadBloc/notification_read_event.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  int page = 1;
  bool isLoading = false;
  List<NotificationModel> allNotifications = [];

  NotificationBloc() : super(NotificationInitialState()) {
    on<FetchNotification>(_onFetchNotification);
    on<FetchMoreNotification>(_onFetchMoreNotification);
  }

  Future<void> _onFetchNotification(
      FetchNotification event, Emitter<NotificationState> emit) async {
    if (event.initialValue == 1) {
      page = 1;
      allNotifications.clear();
    }
    if (event.refreshIndicator) {
      page = 1;
      allNotifications.clear();
    }

    if (page == 1) emit(NotificationLoadingState(allNotifications.cast<NotificationModel>()));

    try {
      List<NotificationModel> notificationArr = await GetapiRepo(
        url: "$notificationUrl?page=$page&per_page=10&fcm_id=${event.fcmToken}",
        fromJson: NotificationModel.fromJson,
        isToken: true,
      ).getData();

      if (allNotifications.isEmpty) {
        allNotifications.addAll(notificationArr);
      } else {
        // Combine the data from new notifications into the first model
        allNotifications[0].data!.notification!.addAll(notificationArr[0].data!.notification as Iterable<Notification>);
      }


      Map<String, int> readStatusMap = {};

      allNotifications[0].data!.notification?.forEach((notification) {
        if (notification.slug != null) {
          readStatusMap[notification.slug!] = notification.isRead ?? 0;
        }
      });


      if(event.context.mounted){
        event.context.read<NotificationReadBloc>().add(
            InitializeNotificationRead(initialData: readStatusMap)
        );
      }

      page++;
      emit(NotificationSuccessState(notificationData: allNotifications));
    } catch (error) {
      emit(NotificationErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onFetchMoreNotification(
      FetchMoreNotification event, Emitter<NotificationState> emit) async {
    if (isLoading) return;

    isLoading = true;
    emit(NotificationLoadingMoreState(allNotifications));

    try {
      List<NotificationModel> notificationArr = await GetapiRepo(
        url: "$notificationUrl?page=$page&per_page=10",
        fromJson: NotificationModel.fromJson,
        isToken: true,
      ).getData();

      if (notificationArr[0].data!.notification!.isNotEmpty) {
        allNotifications[0].data!.notification!.addAll(notificationArr[0].data?.notification as Iterable<Notification>);
        page++;
      }

      Map<String, int> readStatusMap = {};

      allNotifications[0].data!.notification?.forEach((notification) {
        if (notification.slug != null) {
          readStatusMap[notification.slug!] = notification.isRead!;
        }
      });


      if(event.context.mounted){
        event.context.read<NotificationReadBloc>().add(
            InitializeNotificationRead(initialData: readStatusMap)
        );
      }

      emit(NotificationSuccessState(notificationData: allNotifications));
    } catch (error) {
      emit(NotificationErrorState(errorMessage: error.toString()));
    } finally {
      isLoading = false;
    }
  }
}


