

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/bloc/notificationBloc/notification_bloc.dart';
import 'package:newsapp/config/constants.dart';

import 'package:newsapp/utils/widgets/notification_cart.dart';

import '../../../bloc/notificationBloc/notification_event.dart';
import '../../../bloc/notificationBloc/notification_state.dart';
import '../../../config/colors.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';

import '../../../l10n/app_localizations.dart';
import '../../../notification_service.dart';


class NotificationNews extends StatelessWidget {
  const NotificationNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notification,style: const TextStyle(fontSize: 22,fontFamily: fontType),),
        centerTitle: true,
      ),
      body: DisplayNotification());
  }
}

class DisplayNotification extends StatefulWidget {
  const DisplayNotification({super.key});

  @override
  State<DisplayNotification> createState() => _DisplayNotificationState();
}

class _DisplayNotificationState extends State<DisplayNotification> {
  final ScrollController scrollController = ScrollController();
  final FirebaseMessagingService firebaseMessagingService = FirebaseMessagingService();
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    getFcmtoken();
    scrollController.addListener(onScroll);
    initNotification();

  }

  Future<void> initNotification() async {
    final token = await firebaseMessagingService.getToken();
    setState(() {
      fcmToken = token;
    });

 fetcData(fcmToken);
  }

  void fetcData(fcm){
    context.read<NotificationBloc>().add(FetchNotification(context: context, fcmToken: fcm));
  }


  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      context.read<NotificationBloc>().add(FetchMoreNotification(context: context));
    }
  }

  Widget buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return ShimmerWidget(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.1,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
          ),
        );
      },
    );
  }

  Widget buildEmptyNotificationState() {
    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Newspaper illustration
              Container(
                width: MediaQueryHelper.screenWidth(context) * 0.6,
                height: MediaQueryHelper.screenWidth(context) * 0.6,
                decoration: BoxDecoration(
                  color: AppColors().primaryColor.withValues(alpha:0.05),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Newspaper
                      Icon(
                        Icons.newspaper_rounded,
                        size: MediaQueryHelper.screenWidth(context) * 0.25,
                        color: AppColors().primaryColor.withValues(alpha:0.8),
                      ),
                      // Bell with slash overlay
                      Positioned(
                        bottom: MediaQueryHelper.screenWidth(context) * 0.05,
                        right: MediaQueryHelper.screenWidth(context) * 0.05,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha:0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.notifications_off_rounded,
                            size: MediaQueryHelper.screenWidth(context) * 0.08,
                            color: AppColors().primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.05),

              // Headline
              Text(
                AppLocalizations.of(context)!.yourNotificationFeedisQuiet,
                style: TextStyle(
                  fontFamily: fontType,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),

              SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),

              // Subheading
              Text(
                AppLocalizations.of(context)!.checkNotificationChannels,
                style: TextStyle(
                  fontFamily: fontType,
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        GoRouter.of(context).go('/home');
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors().primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: Text(
                       AppLocalizations.of(context)!.goToHomeFeed,
                        style: TextStyle(
                          fontFamily: fontType,
                          color: AppColors().primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotificationList(NotificationState state) {
    final allNotifications = context.read<NotificationBloc>().allNotifications;


    if (allNotifications.isEmpty ||
        allNotifications[0].data == null ||
        allNotifications[0].data!.notification == null ||
        allNotifications[0].data!.notification!.isEmpty) {
      return buildEmptyNotificationState();
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: allNotifications[0].data!.notification!.length + 1,
      itemBuilder: (context, index) {
        if (index == allNotifications[0].data!.notification!.length) {
          if (state is NotificationLoadingMoreState) {
            return  Center(
              child: CircularProgressIndicator(color: AppColors().primaryColor),
            );
          } else {
            return const SizedBox.shrink();
          }
        }

        final notification = allNotifications[0].data!.notification![index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQueryHelper.screenHeight(context) * 0.01,
          ),
          child: GestureDetector(
            onTap: () async {
              final slug = notification.slug;
               print("Vsdvdswvs $slug");
              if(slug!.isEmpty){
                context.go("/home");
              }else {
                checkLimitAndNavigate(context, "$slug?fcmId=$fcmToken");
              }




            },
            child: NotificationCard(
              title: notification.title.toString(),
              time: notification.createdAt.toString(),
              coverimg: notification.image.toString(),
              logo: notification.channelLogo.toString(),
              slug: notification.slug.toString(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors().primaryColor,
      onRefresh: () async {
        context.read<NotificationBloc>().add(
          FetchNotification(refreshIndicator: true, context: context, fcmToken: fcmToken),
        );
      },
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationInitialState ||
              (state is NotificationLoadingState && context.read<NotificationBloc>().allNotifications.isEmpty)) {
            return buildLoadingShimmer();
          } else if (state is NotificationErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 60,
                    color: AppColors().primaryColor,
                  ),

                  SizedBox(height: 10),
                  Text(
                    state.errorMessage,
                    style: TextStyle(
                      fontFamily: fontType,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha:0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<NotificationBloc>().add(
                        FetchNotification(refreshIndicator: true, context: context, fcmToken: fcmToken),
                      );
                    },
                    icon: Icon(Icons.refresh_rounded, color: Colors.white),
                    label: Text(
                      "Try Again",
                      style: TextStyle(
                        fontFamily: fontType,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return buildNotificationList(state);
          }
        },
      ),
    );
  }
}



