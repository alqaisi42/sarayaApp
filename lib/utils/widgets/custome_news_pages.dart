// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import 'package:newsapp/config/colors.dart';

import 'package:remixicon/remixicon.dart';
import 'package:share_plus/share_plus.dart';
import '../../bloc/bookmark/bookmark_article_bloc.dart';
import '../../bloc/channelPageBloc/channel_page_bloc.dart';
import '../../bloc/channelPageBloc/channel_page_event.dart';
import '../../bloc/channelPageBloc/channel_page_state.dart';

import '../../bloc/languageBloc/language_switcher_bloc.dart';
import '../../bloc/newsPage_bloc/newspage_event.dart';
import '../../bloc/newsPage_bloc/newspage_bloc.dart';
import '../../config/check_internet.dart';
import '../../config/constants.dart';

import '../../config/helper/helper_functions.dart';
import '../../config/shimmer.dart';
import 'display_channelpage_news.dart';
import 'no_internet_screen.dart';
import '../../l10n/app_localizations.dart';

class ChannelPage extends StatefulWidget {
  final String slug;
  const ChannelPage({super.key, required this.slug});

  @override
  State<ChannelPage> createState() => _NewsPageState();
}



class _NewsPageState extends State<ChannelPage> {
  String? selectedSortValue;
  String? selectedTopicsValues;
  late final String languageCode;

  // For Internet Check
  List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  late  StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    CheckInternet.initConnectivity().then((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        setState(() {
          _connectionStatus = results;
        });
      }
    });
   languageCode = context.read<LanguageBloc>().state.locale.languageCode;
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        CheckInternet.updateConnectionStatus(results).then((value) {
          setState(() {
            _connectionStatus = value;
            context.read<ChannelPageBloc>().add(FetchChannelPage(widget.slug, refreshIndicator: true,context: context));
            context.read<NewsPageBloc>().add(FetchNewsPagesData(channelSlug: widget.slug, refreshIndicator: true, context: context));
          });
        });
      }
    });



    context.read<ChannelPageBloc>().add(FetchChannelPage(widget.slug, refreshIndicator: true,context: context));
    context.read<NewsPageBloc>().add(FetchNewsPagesData(channelSlug: widget.slug, refreshIndicator: true, context: context));

  }

  TextEditingController searchChanelController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> _refreshContent() async {
    context.read<ChannelPageBloc>().add(FetchChannelPage(widget.slug, refreshIndicator: true,context: context));
    context.read<NewsPageBloc>().add(FetchNewsPagesData(channelSlug: widget.slug, refreshIndicator: true, context: context));
  }

  @override
  Widget build(BuildContext context) {
    return  _connectionStatus.contains(connectivityCheck)
            ?  NoInternetScreen()
            :  RefreshIndicator(
        onRefresh: _refreshContent,
              color: AppColors().primaryColor,
              child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: SafeArea(
              top: true,
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                body: BlocBuilder<ChannelPageBloc, ChannelPageState>(
                  builder: (context, state) {
                    if (state is ChannelPageLoadingState) {
                      return TOIShimmer();
                    } else if (state is ChannelPageErrorState) {
                      return Center(child: Text('${AppLocalizations.of(context)!.error}: ${state.errorMessage}',style: TextStyle(fontFamily: fontType),));
                    } else if (state is ChannelPageSuccessState) {
                      final channelsData = state.channelsPage[0].data;


      
                      return CustomScrollView(

                        controller: context.read<NewsPageBloc>().scrollController,
                        slivers: [
                          SliverAppBar(
                            pinned: true,
                            automaticallyImplyLeading: false,
                            expandedHeight: MediaQueryHelper.screenHeight(context) * 0.2,
                            leading: Padding(
                              padding: EdgeInsets.only(
                                left: MediaQueryHelper.screenWidth(context) * 0.04,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha:  0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Custom back action
                                  },
                                  icon: Icon(
                                    languageCode == 'ar' ? HeroiconsSolid.chevronRight :    HeroiconsSolid.chevronLeft,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                            flexibleSpace: FlexibleSpaceBar(
                              background: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: ImageUtils.networkImage(channelsData?.postImage,width: MediaQueryHelper.screenWidth(context), fit: BoxFit.cover)
                              ),
                            ),
                            actions: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: MediaQueryHelper.screenWidth(context) * 0.04,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha:  0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      final String appLink = '$baseUrl/channels/${channelsData?.slug}';
                                      Share.share(appLink);
                                    },
                                    icon: Icon(
                                      HeroiconsOutline.share,
                                      color: AppColors.whiteColor, // Optional: use theme color
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                PageHeader(channelPageArr: channelsData),
                                SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
                                AboutChanel(channelPageArr: channelsData),
                                SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.03),
                                NewsByChannel(channelPageArr: channelsData,),
                                SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
                                NewsTopicWidget(channelPageArr: channelsData,currentSelectedvalue:selectedTopicsValues),
                                SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
                              ],
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                DisplayChannelPageNews(),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return Center(child: Text(AppLocalizations.of(context)!.noDataAvailable,style: TextStyle(fontFamily: fontType),),);
                  },
                ),
              ),
                      ),
                    ),
            );

  }
}



class PageHeader extends StatelessWidget {
  final dynamic channelPageArr;
  const PageHeader({super.key, this.channelPageArr});



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQueryHelper.screenHeight(context) * 0,
          left: MediaQueryHelper.screenWidth(context) * 0.03,
          right: MediaQueryHelper.screenHeight(context) * 0.03),
      child: Row(
        children: [
          SizedBox(
            width: MediaQueryHelper.screenWidth(context) * 0.22,
            height: MediaQueryHelper.screenWidth(context) * 0.22,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: ImageUtils.networkImage(channelPageArr.logo,fit: BoxFit.fill)),
          ),
          SizedBox(width: MediaQueryHelper.screenWidth(context) * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                channelPageArr.name,
                style: TextStyle(fontSize: 20,fontFamily: fontType),
              ),
              SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.004),
              Row(
                children: [
                  Row(
                    children: [
                      Text(formatNumber(channelPageArr.totalPost,),style: TextStyle(fontFamily: fontType),),
                      SizedBox(
                        width: MediaQueryHelper.screenWidth(context) * 0.01,
                      ),
                      Text(AppLocalizations.of(context)!.newsLabel, style: TextStyle(color: Colors.grey.shade400,fontFamily: fontType),),
                    ],
                  ),
                  SizedBox(
                    width: MediaQueryHelper.screenWidth(context) * 0.04,
                  ),
                  Row(
                    children: [
                      Text(formatNumber(channelPageArr.followCount,),style: TextStyle(fontFamily: fontType),),
                      SizedBox(
                        width: MediaQueryHelper.screenWidth(context) * 0.01,
                      ),
                      Text(
                        AppLocalizations.of(context)!.followers,
                        style: TextStyle(color:  Colors.grey.shade400,fontFamily: fontType),
                      ),
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}


class DisplayPagesInfo extends StatelessWidget {
  final String pageNumber;
  final String txt;

  const DisplayPagesInfo({
    super.key,
    required this.pageNumber,
    required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(pageNumber,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,fontFamily: fontType)),
        Text(txt, style: TextStyle(fontSize: 16, color: AppColors.greyColor,fontFamily: fontType)),
      ],
    );
  }
}


//======================================================================= Channel Description and Follow Button
class AboutChanel extends StatefulWidget {
  final dynamic channelPageArr;
  const AboutChanel({super.key, required this.channelPageArr});

  @override
  AboutChanelState createState() => AboutChanelState();
}

class AboutChanelState extends State<AboutChanel> {
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
  isFollowing = widget.channelPageArr.isFollowed == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQueryHelper.screenHeight(context) * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.channelPageArr.description ?? '',
            style: TextStyle(fontSize: 14, color: AppColors.greyColor,fontFamily: fontType),
          ),
          SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: BlocBuilder<BookmarkArticleBloc, BookmarkArticleState>(builder: (context,state) {
              state as BookmarkArticleAll;
              return SizedBox(
                height: MediaQueryHelper.screenHeight(context) * 0.05,
                width: MediaQueryHelper.screenWidth(context) * 0.3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryHelper.screenWidth(context) * 0.05,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: state.slugs.contains(widget.channelPageArr.slug) ? Theme.of(context).colorScheme.primary  : AppColors().primaryColor,
                    foregroundColor: state.slugs.contains(widget.channelPageArr.slug) ? Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.black : AppColors.whiteColor : AppColors.lightColor,
                    side: state.slugs.contains(widget.channelPageArr.slug)
                        ? BorderSide(color: AppColors().primaryColor, width: 2)
                        : BorderSide.none,
                  ),
                  onPressed: () async {
                    if (state.slugs.contains(widget.channelPageArr.slug)) {
                      context.read<BookmarkArticleBloc>().add(BookmarkArticleRemove(context: context, slug: widget.channelPageArr.slug,slugType: "channel"));
                    } else {
                      context.read<BookmarkArticleBloc>().add(BookmarkArticleAdd(slug: widget.channelPageArr.slug, context: context,slugType: "channel"));
                    }
                    setState(() {});
                  },
                  child: Text(
                    state.slugs.contains(widget.channelPageArr.slug) ? AppLocalizations.of(context)!.following : AppLocalizations.of(context)!.follow,
                    style:  TextStyle(
                      fontSize: 16,
                      fontFamily: fontType
                    ),
                  ),
                ),
              );
            })),

        ],
      ),
    );
  }
}



// ================================================================= Sorting News
class NewsByChannel extends StatefulWidget {
  final dynamic channelPageArr;

  const NewsByChannel({super.key, this.channelPageArr,});

  @override
  NewsByChannelState createState() => NewsByChannelState();
}

class NewsByChannelState extends State<NewsByChannel> {
  late String selectedSortOption = AppLocalizations.of(context)!.all;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQueryHelper.screenHeight(context) * 0.02,
        right: MediaQueryHelper.screenHeight(context) * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.newsBy} ${widget.channelPageArr.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: fontType),
              ),
            ],
          ),
          const SizedBox(height: 8), // Add some spacing
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.sortBy,
                style: TextStyle(fontSize: 16, color: AppColors.greyColor, fontFamily: fontType),
              ),
              const SizedBox(width: 8),

              SizedBox(
                width: MediaQueryHelper.screenWidth(context) * 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors().primaryColor.withValues(alpha: 0.5)),
                    // Background color removed
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSortOption,
                        icon: Container(
                          decoration: BoxDecoration(

                            color: AppColors().primaryColor.withValues(alpha:  0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Remix.arrow_down_s_line,
                            color: AppColors().primaryColor,
                            size: 20,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        elevation: 8,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontType,
                        ),
                        items: <String>[
                          AppLocalizations.of(context)!.all,
                          AppLocalizations.of(context)!.newest,
                          AppLocalizations.of(context)!.mostViewed,
                          AppLocalizations.of(context)!.mostRead
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                getIconForOption(value, context),
                                 SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: fontType,
                                      color: Theme.of(context).colorScheme.brightness == Brightness.light
                                          ? AppColors.darkScondryColor
                                          : AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSortOption = newValue!;
                          });
                          context.read<NewsPageBloc>().add(FetchNewsPagesData(
                              channelSlug: widget.channelPageArr.slug,
                              sortValue: selectedSortOption,
                              channelCategory: "all",
                              refreshIndicator: false,
                              context: context
                          ));
                        },
                        isExpanded: true,
                        isDense: true,
                        hint: Text(
                          AppLocalizations.of(context)!.sortBy,
                          style: TextStyle(
                            fontSize: 19,
                            fontFamily: fontType,

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }


  Widget getIconForOption(String option, BuildContext context) {
    final Color iconColor = AppColors().primaryColor;

    if (option == AppLocalizations.of(context)!.all) {
      return Icon(Remix.list_check, size: 20, color: iconColor);
    } else if (option == AppLocalizations.of(context)!.newest) {
      return Icon(Remix.time_line, size: 20, color: iconColor);
    } else if (option == AppLocalizations.of(context)!.mostViewed) {
      return Icon(Remix.eye_line, size: 20, color: iconColor);
    } else if (option == AppLocalizations.of(context)!.mostRead) {
      return Icon(Remix.book_open_line, size: 20, color: iconColor);
    }

    return Icon(Remix.filter_3_line, size: 20, color: iconColor);
  }
}



class NewsTopicWidget extends StatefulWidget {
  final dynamic channelPageArr;
  final String? currentSelectedvalue;

  const NewsTopicWidget({super.key, required this.channelPageArr, this.currentSelectedvalue});

  @override
  State<NewsTopicWidget> createState() => _NewsTopicWidgetState();
}
class _NewsTopicWidgetState extends State<NewsTopicWidget> {
  String selectedTopic = '';

  @override
  void initState() {
    super.initState();
    // Set initial value after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        setState(() {
          selectedTopic = AppLocalizations.of(context)!.all;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topics = widget.channelPageArr.topicsList;
    final allText = AppLocalizations.of(context)!.all;

    if (topics == null || topics.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noTopicsAvailable,
          style: TextStyle(fontFamily: fontType),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(left: MediaQueryHelper.screenHeight(context) * 0.005),
        child: Row(
          children: [
            // Add "All" chip at the start
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTopic = allText;
                  });
                  context.read<NewsPageBloc>().add(
                      FetchNewsPagesData(
                          channelSlug: widget.channelPageArr.slug,
                          sortValue: "all",
                          channelCategory: "all",
                          refreshIndicator: false,
                          context: context
                      )
                  );
                },
                child: Chip(
                  label: Text(
                    allText,
                    style: TextStyle(
                        fontSize: 16,
                        color: selectedTopic == allText ? AppColors.whiteColor : null,
                        fontFamily: fontType
                    ),
                  ),
                  backgroundColor: selectedTopic == allText ? AppColors().primaryColor : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            // Generate rest of the topics
            ...List.generate(
              topics.length,
                  (index) {
                final dataItem = topics[index];
                final isSelected = selectedTopic == dataItem.name.toString();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTopic = dataItem.name.toString();
                      });
                      context.read<NewsPageBloc>().add(
                          FetchNewsPagesData(
                              channelSlug: widget.channelPageArr.slug,
                              sortValue: widget.currentSelectedvalue.toString(),
                              channelCategory: dataItem.name.toString(),
                              refreshIndicator: false,
                              context: context
                          )
                      );
                    },
                    child: Chip(
                      label: Text(
                        dataItem.name ?? '',
                        style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? AppColors.whiteColor : null,
                            fontFamily: fontType
                        ),
                      ),
                      backgroundColor: isSelected ? AppColors().primaryColor : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}










