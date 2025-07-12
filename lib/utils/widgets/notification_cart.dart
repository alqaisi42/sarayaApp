import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/config/constants.dart';


import '../../bloc/notificationReadBloc/notification_read_bloc.dart';
import '../../bloc/notificationReadBloc/notification_read_state.dart';
import '../../config/helper/helper_functions.dart';


class NotificationCard extends StatelessWidget {
  final String title;
  final String time;
  final String coverimg;
  final String logo;
  final String slug;

  const NotificationCard({
    super.key,
    required this.title,
    required this.time,
    required this.coverimg,
    required this.logo,
    required this.slug
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQueryHelper.screenWidth(context) * 0.04,
          right: MediaQueryHelper.screenWidth(context) * 0.04,
          top: MediaQueryHelper.screenWidth(context) * 0.02),
      height: MediaQueryHelper.screenHeight(context) * 0.1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container for dot and avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<NotificationReadBloc, NotificationReadState>(
                builder: (context, state) {
                  final isRead = state.isReadValues[slug] ?? 0;
                  return isRead == 0
                      ? Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  )
                      :  SizedBox(width: 0);
                },
              ),
              SizedBox(width: 5),
              CircleAvatar(
                radius: 16,
                backgroundImage: ImageUtils.networkImageProvider(logo),
              ),
            ],
          ),
          SizedBox(width: MediaQueryHelper.screenWidth(context) * 0.03),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQueryHelper.screenWidth(context) * 0.43,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          fontFamily: fontType,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontFamily: fontType
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image(
                    image: ImageUtils.networkImageProvider(coverimg),
                    width: MediaQueryHelper.screenWidth(context) * 0.32, // Slightly reduced width
                    height: MediaQueryHelper.screenHeight(context) * 0.093,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


