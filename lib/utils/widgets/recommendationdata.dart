


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../../config/colors.dart';
import '../../config/constants.dart';


import '../../config/helper/helper_functions.dart';
import 'favorite_button.dart';

class RecommendationList extends StatelessWidget {
  final int id;
  final int viewCount;
  final String coverImg;
  final String title;
  final String channelSlug;
  final String logo;
  final String publisher;
  final String time;
  final String slug;
  final String postType;
  final String videoThumb;
  final String videoUrl;


  const RecommendationList({
    super.key,
    required this.id,
    required this.viewCount,
    required this.coverImg,
    required this.title,
    required this.channelSlug,
    required this.logo,
    required this.publisher,
    required this.time,
    required this.slug,
    required this.videoUrl,
    required this.postType,
    required this.videoThumb
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryHelper.screenWidth(context) * 0.04),
      child: GestureDetector(
        onTap: () async {

          checkLimitAndNavigate(context, slug);

        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQueryHelper.screenWidth(context) * 0.02,
              vertical: MediaQueryHelper.screenHeight(context) * 0.01,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [



            Stack(
            children: [
            SizedBox(
            width: double.infinity,
              height: MediaQueryHelper.screenHeight(context) * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ImageUtils.networkImage(
                  postType == 'video' ? videoThumb : coverImg,
                  fit: BoxFit.fitWidth,
                  width: MediaQueryHelper.screenWidth(context) * 0.3,
                  height: MediaQueryHelper.screenHeight(context) * 0.1,
                ),
              ),
            ),
              // Add a semi-transparent black overlay
              if (postType == 'video')
                Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha:0.3), // Adjust opacity as needed
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              if (postType == 'video') // Ensure condition is dynamic
          Positioned.fill(
        child: Center(
        child: Icon(
          Icons.play_circle_fill,
          color: Colors.white.withValues(alpha:0.9),
          size: 60,
        ),
      ),
    ),
    ],
    ),

    SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: fontType,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push('/customNewsPage/$channelSlug');
                      },
                      child: Row(
                        children: [
                          // ImageUtils.networkImage(logo,fit: BoxFit.cover,height: MediaQueryHelper.screenHeight(context) * 0.04),
                          Container(
                              width: 30,
                              height: 30,
                              child: ClipOval(
                                child: Container(
                                  color: Colors.white, // Background color
                                  width: 40,
                                  height: 40,
                                  child: Image.asset(
                                    'assets/img/new_logo.png',
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              )
                          ),
                          SizedBox(width: MediaQueryHelper.screenWidth(context) * 0.02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                publisher,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: fontType,
                                ),
                              ),
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.greyColor,
                                  fontFamily: fontType
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FavoriteButton(postSlug: slug, postImg: coverImg,),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}





