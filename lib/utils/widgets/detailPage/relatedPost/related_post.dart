

import 'package:flutter/material.dart';

import 'package:newsapp/config/constants.dart';

import '../../../../config/helper/helper_functions.dart';
import '../../../../l10n/app_localizations.dart';




class RelatedPostDisplay extends StatelessWidget {
  final List? realtedPost;
  final String currentPostslug;

  const RelatedPostDisplay({super.key, required this.realtedPost,required this.currentPostslug});

  @override
  Widget build(BuildContext context) {
    if (realtedPost == null || realtedPost!.isEmpty) {
      return const SizedBox.shrink();
    }

    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
           Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.relatedPosts,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,

                fontFamily: fontType
              ),
            ),
          ),


          SizedBox(
            height: MediaQueryHelper.screenHeight(context) * 0.35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: realtedPost!.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final post = realtedPost![index];
                return GestureDetector(
                  onTap: () {
                    final slug = post.slug ?? "";
                    checkLimitAndNavigate(context, slug,'fromRelated');

                    },
                  child: Container(
                    width: MediaQueryHelper.screenWidth(context) * 0.8,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),

                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: ImageUtils.networkImage(
                                post.type == 'video' ? post.videoThumb : post.image,
                                height: MediaQueryHelper.screenHeight(context) * 0.2,
                                width: MediaQueryHelper.screenWidth(context)
                              ),
                            ),
                            if (post.type == 'video')
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha:0.3), // Adjust opacity as needed
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            if (post.type == 'video')
                              Positioned.fill(
                                child: Center(
                                  child: Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.white.withValues(alpha:0.9),
                                    size: 65,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[500]!, width: 0.5), // Bottom border
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),

                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Channel Info Row
                                Row(
                                  children: [
                                    // Channel Logo
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: ImageUtils.networkImageProvider(post.channelLogo),
                                          alignment: Alignment.center,
                                        ),
                                        color: Colors.grey[200],
                                      ),
                                      child: ClipOval(
                                        child: Image(
                                          image: ImageUtils.networkImageProvider(post.channelLogo),
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,


                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Channel Name and Publish Date
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.channelName ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: fontType,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            post.publishDate ?? '',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                              fontFamily: fontType,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Title
                                Text(
                                  post.title ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: fontType,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        )


                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );

  }
}