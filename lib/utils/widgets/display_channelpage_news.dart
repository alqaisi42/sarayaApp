// ignore_for_file: prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/constants.dart';
import 'package:share_plus/share_plus.dart';

import '../../bloc/bookmark/bookmark_article_bloc.dart';
import '../../bloc/commentsCountBloc/comment_count_bloc.dart';
import '../../bloc/commentsCountBloc/comment_count_state.dart';
import '../../bloc/newsPage_bloc/newspage_state.dart';
import '../../bloc/newsPage_bloc/newspage_bloc.dart';
import '../../../l10n/app_localizations.dart';

import '../../bloc/viewCountBloc/view_count_bloc.dart';
import '../../bloc/viewCountBloc/view_count_event.dart';
import '../../bloc/viewCountBloc/view_count_state.dart';
import '../../config/googleAdMob/banner_ad.dart';
import '../../config/helper/helper_functions.dart';
import '../../config/shimmer.dart';




class DisplayChannelPageNews extends StatefulWidget {

  const DisplayChannelPageNews({super.key});

  @override
  State<DisplayChannelPageNews> createState() => _DisplayChannelPageNews();
}
class _DisplayChannelPageNews extends State<DisplayChannelPageNews> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsPageBloc, NewsPageState>(
      builder: (context, state) {
        if (state is NewsPageInitialState ||
            (state is NewsPageStateLoadingState && state.newsPageData.isEmpty)) {
          return  _buildLoadingShimmer(context);
        }
        final bloc = context.read<NewsPageBloc>();
        final allData = bloc.newsPage.expand((response) => response.data ?? []).toList();
        if (allData.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.noDataAvailable,style: TextStyle(fontFamily: fontType),));
        }
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics:  NeverScrollableScrollPhysics(),
              itemCount: allData.length,
              itemBuilder: (context, index) {
                final item = allData[index];
               if(bloc.isAdsFree == false){
                 if (index > 0 && index % 4 == 0) {
                   return const Padding(
                     padding: EdgeInsets.symmetric(vertical: 10.0),
                     child: AdBannerWidget(),
                   );
                 }
               }
                final dataIndex = index - (index ~/ 4);

                if (dataIndex >= allData.length) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.only(
                    left: MediaQueryHelper.screenWidth(context) * 0.03,
                    bottom: MediaQueryHelper.screenHeight(context) * 0.02,
                  ),
                  child: DisplayTrending(
                     category: item.topicName ?? '',
                     image: item.image ?? '',
                      title: item.title ?? '',
                      date: item.publishDate ?? '',
                      viewCount: item.viewCount ?? 0,
                      totalComment: item.comment ?? 0,
                      slug: item.slug ?? "",

                  ),
                );
              },
            ),
            if (state is NewsPageStateLoadingMoreState)
               Padding(
                padding: EdgeInsets.all(8.0),
                child: _buildLoadingShimmer(context),
              ),
          ],
        );
      },
    );
  }
}
Widget _buildLoadingShimmer(context) {
  return SizedBox(
    height: MediaQueryHelper.screenHeight(context) * 0.5,
    child: ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return ShimmerWidget(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
          ),
        );
      },
    ),
  );
}


class DisplayTrending extends StatefulWidget {

  final String? category;
  final String? image;
  final String? title;
  final String? date;
  final int? viewCount;
  final int? totalComment;
  final String? slug;


  const DisplayTrending({super.key, this.category, this.image, this.title, this.date, this.viewCount, this.totalComment, this.slug});

  @override
  State<DisplayTrending> createState() => _DisplayTrendingState();
}

class _DisplayTrendingState extends State<DisplayTrending> {


  @override
  void initState() {
    super.initState();
    context.read<ViewCountBloc>().add(UpdateViewCount(slug:widget.slug.toString(), apiViewCount: widget.viewCount!.toInt() ));
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        checkLimitAndNavigate(context, widget.slug.toString());
      },
      child: Container(
        margin: EdgeInsets.only(right: MediaQueryHelper.screenWidth(context) * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primary,

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Image Section with better overlay
              Stack(
                children: [
                  Container(
                    height: MediaQueryHelper.screenHeight(context) * 0.22,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: ImageUtils.networkImageProvider(widget.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.4),
                          ],
                          stops: [0.0, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Enhanced Category Tag with premium styling
                  Positioned(
                    top: MediaQueryHelper.screenHeight(context) * 0.018,
                    left: MediaQueryHelper.screenWidth(context) * 0.03,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQueryHelper.screenWidth(context) * 0.035,
                        vertical: MediaQueryHelper.screenHeight(context) * 0.008,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors().primaryColor,
                            AppColors().primaryColor.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors().primaryColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.category.toString().toUpperCase(),
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 11,
                          fontFamily: fontType,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  // Bookmark and Share buttons
                  Positioned(
                    top: MediaQueryHelper.screenHeight(context) * 0.018,
                    right: MediaQueryHelper.screenWidth(context) * 0.03,
                    child: Row(
                      children: [
                        // Bookmark Button
                        // GestureDetector(
                        //   onTap: () {
                        //
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.all(8),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white.withValues(alpha: 0.9),
                        //       borderRadius: BorderRadius.circular(12),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.black.withValues(alpha: 0.1),
                        //           blurRadius: 4,
                        //           offset: Offset(0, 2),
                        //         ),
                        //       ],
                        //     ),
                        //     child: Icon(
                        //       Icons.bookmark_border,
                        //       size: 18,
                        //       color: AppColors().primaryColor,
                        //     ),
                        //   ),
                        // ),
                        BlocBuilder<BookmarkArticleBloc, BookmarkArticleState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () => BookmarkUtils.toggleBookmark(context, widget.slug.toString()),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  BookmarkUtils.getBookmarkIcon(context, widget.slug.toString()),
                                  size: 18,
                                  color: BookmarkUtils.getBookmarkIconColor(context, widget.slug.toString()),
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(width: 8),
                        // Share Button
                        GestureDetector(
                          onTap: () {
                            final String appLink = '$baseUrl/posts/${widget.slug}';
                            Share.share(appLink,);
                            },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.share,
                              size: 18,
                              color: AppColors().primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Enhanced Content Section
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with enhanced typography
                    Text(
                      widget.title.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: fontType,
                        fontWeight: FontWeight.w800,
                        height: 1.4,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.018),

                    // Enhanced Stats Row with better visual hierarchy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side - Views and Comments with enhanced styling
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),

                              ),
                              child: NewsPageViewCountDisplay(
                                slug: widget.slug.toString(),
                                initialViewCount: widget.viewCount!.toInt(),
                              ),
                            ),

                            SizedBox(width: 12),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),

                              ),
                              child: NewsPageCommentCountDisplay(
                                slug: widget.slug.toString(),
                                initialCommentCount: widget.viewCount!.toInt(),
                              ),
                            ),
                          ],
                        ),

                        // Right side - Date with premium styling
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey.withValues(alpha: 0.1),
                                Colors.grey.withValues(alpha: 0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),

                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),

                                child: Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: AppColors.greyColor,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                widget.date.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.greyColor,
                                  fontFamily: fontType,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return InkWell(
  //     onTap: () async {
  //
  //
  //       checkLimitAndNavigate(context, widget.slug.toString());
  //     },
  //     child: Container(
  //       margin: EdgeInsets.only(right: MediaQueryHelper.screenWidth(context) * 0.03),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         color: Theme.of(context).colorScheme.primary,
  //       ),
  //       child: Padding(
  //         padding: EdgeInsets.all(8),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Stack(
  //               children: [
  //                 Container(
  //                   height: MediaQueryHelper.screenHeight(context) * 0.18,
  //                   width: double.infinity,
  //
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                     image: DecorationImage(
  //                       image: ImageUtils.networkImageProvider(widget.image),
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 )
  //                 ,
  //                 Positioned(
  //                   top: MediaQueryHelper.screenHeight(context) * 0.01,
  //                   left: MediaQueryHelper.screenWidth(context) * 0.03,
  //                   child: Container(
  //                     padding: EdgeInsets.symmetric(
  //                         horizontal: MediaQueryHelper.screenWidth(context) * 0.02,
  //                         vertical: MediaQueryHelper.screenHeight(context) * 0.002),
  //                     decoration: BoxDecoration(
  //                       color: AppColors().primaryColor,
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                     child: Text(
  //                       widget.category.toString(),
  //                       style: TextStyle(
  //                         color: AppColors.whiteColor,
  //                         fontSize: 1,
  //                         fontFamily: fontType,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
  //             Text(
  //               widget.title.toString(),
  //               style: TextStyle(
  //                   fontSize: 14,
  //                   fontFamily: fontType,
  //                   fontWeight: FontWeight.w600),
  //             ),
  //             SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Row(
  //                   children: [
  //                     // ViewCountDisplay(slug: widget.slug.toString(), initialViewCount: widget.viewCount!.toInt(), postImg: '',isNeed: false,),
  //                     NewsPageViewCountDisplay(slug: widget.slug.toString(), initialViewCount: widget.viewCount!.toInt(),),
  //                     SizedBox(width: 10,),
  //                     // Icon(
  //                     //   HeroiconsOutline.chatBubbleBottomCenterText,
  //                     //   size: 20,
  //                     //   color: AppColors.greyColor,
  //                     // ),
  //                     SizedBox(width: 5,),
  //                     // Text(formatNumber(widget.totalComment!)),
  //                     NewsPageCommentCountDisplay(slug: widget.slug.toString(), initialCommentCount: widget.viewCount!.toInt(),)
  //                   ],
  //                 ),
  //
  //                 Text(
  //                   widget.date.toString(),
  //                   style: TextStyle(
  //                       fontSize: 12,
  //                       color: AppColors.greyColor,
  //                       fontFamily: fontType),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class NewsPageCommentCountDisplay extends StatelessWidget {
  final String slug;
  final int initialCommentCount;

  const NewsPageCommentCountDisplay({
    super.key,
    required this.slug,
    required this.initialCommentCount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentCountBloc, CommentCountState>(
      buildWhen: (previous, current) {
        return previous.commentCounts[slug] != current.commentCounts[slug];
      },
      builder: (context, state) {
        final commentCount = state.commentCounts[slug] ?? initialCommentCount;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                HeroiconsOutline.chatBubbleBottomCenterText,
                size: 14,
                color: Colors.green.shade600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              formatNumber(commentCount),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        );
      },
    );
  }
}

class NewsPageViewCountDisplay extends StatelessWidget {
  final String slug;
  final int initialViewCount;

  const NewsPageViewCountDisplay({
    super.key,
    required this.slug,
    required this.initialViewCount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewCountBloc, ViewCountState>(
      builder: (context, state) {
        final viewCount = state.viewCounts[slug] ?? initialViewCount;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                HeroiconsOutline.eye,
                size: 14,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              formatNumber(viewCount),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        );
      },
    );
  }
}