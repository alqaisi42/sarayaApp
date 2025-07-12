import 'dart:async';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:newsapp/Model/auth%20model/auth_response_model.dart';

import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/constants.dart';




import '../../bloc/bookmark/bookmark_article_bloc.dart';
import '../../bloc/bookmarkBloc/bookmakr_event.dart';
import '../../bloc/bookmarkBloc/bookmark_bloc.dart';
import '../../bloc/bookmarkBloc/bookmark_state.dart';
import '../../config/check_internet.dart';
import '../../config/helper/helper_functions.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';
import '../../config/shimmer.dart';
import '../../../l10n/app_localizations.dart';

import '../../utils/widgets/no_internet_screen.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}


class _BookmarksState extends State<Bookmarks> {
  String? token;
  bool isLoading = true;

  List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeToken();
    CheckInternet.initConnectivity().then((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        setState(() {
          _connectionStatus = results;
        });
      }
    });

    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        CheckInternet.updateConnectionStatus(results).then((value) {
          setState(() {
            _connectionStatus = value;
            context.read<BookmarkBloc>().add(FetchBookmark(initialValue: 1, context: context));
          });
        });
      }
    });


  }

  Future<void> _initializeToken() async {
    AuthResponse? fetchedToken = await HiveStorage().getToken();
    if (mounted) {
      setState(() {
        token = fetchedToken?.data?.token;
        isLoading = false;
      });

      if (token != null && token!.isNotEmpty) {
        context.read<BookmarkBloc>().add(FetchBookmark(initialValue: 1, context: context));
      }
    }


  }

  Future<void> _refreshContent() async {
    context.read<BookmarkBloc>().add(FetchBookmark(initialValue: 1, context: context));
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus.contains(connectivityCheck)
        ? NoInternetScreen()
        : Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQueryHelper.screenHeight(context) * 0.06),
        child: BookmarkHeader(),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : (token != null)
          ? RefreshIndicator(
        onRefresh: _refreshContent,
        color: AppColors().primaryColor,
        child: BookmarkSection(),
      )
          : BookmarkWithoutLoginUI(),
    );

  }
}





class BookmarkSection extends StatefulWidget {
  const BookmarkSection({super.key,required });

  @override
  State<BookmarkSection> createState() => _BookmarkSection();
}
class _BookmarkSection extends State<BookmarkSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<BookmarkBloc>().add(FetchMoreBookmark(context: context));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        final bloc = context.read<BookmarkBloc>();
        final allData = bloc.bookmarks.expand((response) => response.data ?? []).toList();

        if (state is BookmarkInitialState || (state is BookmarkLoadingState && allData.isEmpty)) {
          return _buildLoadingShimmer();
        } else if (state is BookmarkErrorState && allData.isEmpty) {
          return Center(child: Text(state.errorMessage.toString()));
        } else {

          if(allData.isEmpty){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 70,),
                  Text(AppLocalizations.of(context)!.noBookMarkFOund)
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: allData.length + 1,
            itemBuilder: (context, index) {
              if (index == allData.length) {
                if (state is BookmarkLoadingMoreState) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          CircularProgressIndicator(color: AppColors().primaryColor),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }
              final list = allData[index];
              return GestureDetector(
                  onTap: () async {


                    checkLimitAndNavigate(context, list.slug);
                  },
                  child: BookmarkItem(bookmark: list));
            },
          );
        }
      },
    );
  }
}

class BookmarkItem extends StatelessWidget {
  final dynamic bookmark;

  const BookmarkItem({super.key, required this.bookmark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQueryHelper.screenWidth(context);
    final screenHeight = MediaQueryHelper.screenHeight(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.02,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.08),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        height: screenHeight * 0.15,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced image section
              SizedBox(
                width: screenWidth * 0.3,
                height: screenHeight * 0.15,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: ImageUtils.networkImage(
                        bookmark.type == 'video' ? bookmark.videoThumb : bookmark.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (bookmark.type == 'video')
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha:0.2),
                                Colors.black.withValues(alpha:0.5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (bookmark.type == 'video')
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha:0.85),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha:0.2),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    // Type indicator badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha:0.85),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          bookmark.type == 'video' ? 'Video' : 'Article',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Enhanced content section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title with improved typography
                      Text(
                        bookmark.title ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: fontType,
                          height: 1.3,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Date and actions row at bottom
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Date with enhanced icon
                          Row(
                            children: [
                              Icon(
                                HeroiconsSolid.clock,
                                size: 14,
                                color: AppColors.greyColor.withValues(alpha:0.8),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                bookmark.publishDate ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.greyColor.withValues(alpha:0.8),
                                  fontFamily: fontType,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          // Remove favorite button
                          Transform.scale(
                            scale: 0.9,
                            child: RemoveFavoriteButton(
                              postSlug: bookmark.slug ?? "",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class RemoveFavoriteButton extends StatefulWidget {
  final String postSlug;

  const RemoveFavoriteButton({
    super.key,
    required this.postSlug,
  });

  @override
  State<RemoveFavoriteButton> createState() => _RemoveFavoriteButtonState();
}
class _RemoveFavoriteButtonState extends State<RemoveFavoriteButton> {

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }



  @override
  Widget build(BuildContext context) {


    return BlocBuilder<BookmarkArticleBloc, BookmarkArticleState>(

        builder: (context, state) {
          state as BookmarkArticleAll;
          return IconButton(
            onPressed: () {

              if(state.slugs.contains(widget.postSlug)){
                context.read<BookmarkArticleBloc>().add(BookmarkArticleRemove(slug: widget.postSlug, context: context,slugType: "bookmark"));
              }
              setState(() {

              });
            },
            icon: Icon(
              state.slugs.contains(widget.postSlug)
                  ? HeroiconsSolid.bookmark
                  : HeroiconsOutline.bookmark,
              color: state.slugs.contains(widget.postSlug)
                  ? AppColors().primaryColor
                  : Colors.grey.shade500,
            ),
          );
        }
    );
  }
}




class BookmarkHeader extends StatelessWidget {
  const BookmarkHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.bookmarks,
                style:  TextStyle(fontSize: 22, fontFamily: fontType),
              ),
              Text(
                AppLocalizations.of(context)!.collectionOfNoteworthyReads,
                style:  TextStyle(
                    fontSize: 16,
                    color: AppColors.greyColor,
                    fontFamily: fontType),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
Widget _buildLoadingShimmer() {
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



class BookmarkWithoutLoginUI extends StatelessWidget {
  const BookmarkWithoutLoginUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.youNeedToLogInToViewThisPage,style: TextStyle(fontFamily: fontType),),
              SizedBox(
                height: 10,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: MediaQueryHelper.screenWidth(context) * 0.04) ,child:  SizedBox(
                width: MediaQueryHelper.screenWidth(context),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    GoRouter.of(context).push('/signin');
                  },
                  child: Text(AppLocalizations.of(context)!.login,style: TextStyle(fontFamily: fontType),),
                ),
              ),),


            ],
          ),
        )
      ],
    );
  }
}
