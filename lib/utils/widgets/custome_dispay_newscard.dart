import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'package:newsapp/config/colors.dart';

import '../../bloc/viewCountBloc/view_count_bloc.dart';
import '../../bloc/viewCountBloc/view_count_state.dart';
import '../../config/constants.dart';

import '../../config/helper/helper_functions.dart';
import 'favorite_button.dart';

class DisplayPopularNews extends StatefulWidget {
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
  final String video;
  const DisplayPopularNews({
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
    required this.postType,
    required this.videoThumb,
    required this.video
  });

  @override
  State<DisplayPopularNews> createState() => _DisplayPopularNewsState();
}


class _DisplayPopularNewsState extends State<DisplayPopularNews> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const fallbackUrl = 'https://pbs.twimg.com/profile_images/1882135977969262592/PTzP40KK_400x400.jpg';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        // horizontal: 12,
        vertical: MediaQueryHelper.screenHeight(context) * 0.01,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  0.1),
            blurRadius: 10, 
            spreadRadius: 1, 
            offset: Offset(0, 4), 
          ),

        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'news-${widget.slug}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: ImageUtils.networkImage(
                          widget.postType == 'video' ? widget.videoThumb : widget.coverImg,
                          fit: BoxFit.cover,
                          width: MediaQueryHelper.screenWidth(context) * 0.32,
                          height: MediaQueryHelper.screenHeight(context) * 0.12,
                        ),
                      ),
                    ),
                    if (widget.postType == 'video')
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha:0.3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    if (widget.postType == 'video')
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white.withValues(alpha:0.9),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: MediaQueryHelper.screenHeight(context) * 0.12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style:  TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: fontType,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
                            Text(
                              widget.title,
                              style:  TextStyle(
                                fontSize: 12,
                                fontFamily: fontType,
                               color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 0.22,
              color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {

                    GoRouter.of(context).push("/customNewsPage/${widget.channelSlug}");
                  },
                  child: Row(
                    children: [
                      // Container(
                      //   width: 30,
                      //   height: 30,
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     image: DecorationImage(
                      //       image: ImageUtils.networkImageProvider(widget.logo),
                      //       fit: BoxFit.contain,
                      //     ),
                      //   ),
                      // ),

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
                      Text(
                        widget.publisher,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: fontType,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: MediaQueryHelper.screenWidth(context) * 0.015),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color:AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                       SizedBox(width: MediaQueryHelper.screenWidth(context) * 0.015),
                      Text(
                        widget.time,
                        style: TextStyle(
                          color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
                          fontSize: 12,
                          fontFamily: fontType,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                ViewCountDisplay(
                  slug: widget.slug,
                  initialViewCount: widget.viewCount,
                  postImg: widget.coverImg,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class ViewCountDisplay extends StatelessWidget {
  final String slug;
  final String postImg;
  final int initialViewCount;
  final bool? isNeed;

  const ViewCountDisplay({
    super.key,
    required this.slug,
    required this.initialViewCount,
    required this.postImg,
    this.isNeed =  true
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewCountBloc, ViewCountState>(
      buildWhen: (previous, current) {
        return previous.viewCounts[slug] != current.viewCounts[slug];
      },
      builder: (context, state) {
        final viewCount = state.viewCounts[slug] ?? initialViewCount;

        return Row(
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(5),

              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility_rounded,
                        size: 14,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formatNumber(viewCount),
                        style:  TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // const SizedBox(width: 10),
          if(isNeed == true)...[
            FavoriteButton(
              postSlug: slug,
              postImg: '',
            ),
          ]
          ],
        );
      },
    );
  }
}


// class ViewCountDisplay extends StatelessWidget {
//   final String slug;
//   final String postImg;
//   final int initialViewCount;
//
//   const ViewCountDisplay({
//     super.key,
//     required this.slug,
//     required this.initialViewCount,
//     required this.postImg
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ViewCountBloc, ViewCountState>(
//       buildWhen: (previous, current) {
//         return previous.viewCounts[slug] != current.viewCounts[slug];
//       },
//       builder: (context, state) {
//         final viewCount = state.viewCounts[slug] ?? initialViewCount;
//
//         return Row(
//           children: [
//             Icon(HeroiconsOutline.eye, color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],size: 18,),
//             SizedBox(width: 2),
//             Text(
//               formatNumber(viewCount),
//               style: TextStyle(
//                 color:AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
//                 fontSize: 14,
//               ),
//             ),
//             SizedBox(width: 10),
//             FavoriteButton(
//               postSlug: slug, postImg: '',
//             )
//           ],
//         );
//       },
//     );
//   }
// }