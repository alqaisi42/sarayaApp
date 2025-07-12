


import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';





import '../../../l10n/app_localizations.dart';

import '../../../bloc/categoryNewsBloc/category_bloc.dart';
import '../../../bloc/categoryNewsBloc/category_event.dart';
import '../../../bloc/categoryNewsBloc/category_state.dart';
import '../../../config/check_internet.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../config/googleAdMob/banner_ad.dart';
import '../../../config/helper/empty_state_ui.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';
import '../../../utils/widgets/custome_dispay_newscard.dart';
import '../../../utils/widgets/no_internet_screen.dart';



class CategoryData extends StatefulWidget {
  final String category;

  const CategoryData({super.key, required this.category});

  @override
  State<CategoryData> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryData> {

  // For Internet Check
  List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;



  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchCategoryContent(category: widget.category,context: context));


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
            context.read<CategoryBloc>().add(FetchCategoryContent(refreshIndicator: true, category: widget.category,context: context));
          });
        });
      }
    });

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
        :  Scaffold(
      appBar: AppBar(title: Text(widget.category,style: TextStyle(fontFamily: fontType),),),
      body: RefreshIndicator(
        color: AppColors().primaryColor,
        onRefresh: () async {
          context.read<CategoryBloc>().add(FetchCategoryContent(refreshIndicator: true, category: widget.category,context: context));
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryInitialState || (state is CategoryLoadingState && state.categoryList.isEmpty)) {
              return _buildLoadingShimmer();
            } else if (state is CategoryErrorState && context.read<CategoryBloc>().categoryListArr.isEmpty) {
              return Center(child: Text('${AppLocalizations.of(context)!.error}: ${state.errorMessage}'));
            } else {
              return _buildNewsList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final bloc = context.read<CategoryBloc>();
        final allData = bloc.categoryListArr.expand((response) => response.data ?? []).toList();

        if(allData.isEmpty){
          return EmptyStateWidget(
            title: '${widget.category} ${AppLocalizations.of(context)!.topics} ${AppLocalizations.of(context)!.isCurrentlyEmpty}',
            customImage: Image.asset(
              'assets/img/empty.png',
              width: MediaQueryHelper.screenWidth(context) * 0.65,
            ),
            buttonText:AppLocalizations.of(context)!.retry,
            onButtonPressed: () {
              context.read<CategoryBloc>().add(FetchCategoryContent(refreshIndicator: true, category: widget.category,context: context));
            },

          );
        }

        return ListView.builder(
          controller: bloc.scrollController,
          itemCount: allData.length + 1,
          itemBuilder: (context, index) {
            if (index == allData.length) {
              if (state is CategoryLoadingMoreState) {
                return Center(child: CircularProgressIndicator(color: AppColors().primaryColor));
              } else {
                return const SizedBox.shrink();
              }
            }

            if (bloc.showAds == false) {
              if (index > 0 && index % 4 == 0) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: AdBannerWidget(),
                );
              }
            }

            final item = allData[index];
            return GestureDetector(
              onTap: () async {

                checkLimitAndNavigate(context, item.slug.toString());


                },
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: MediaQueryHelper.screenWidth(context) * 0.03),
                child:DisplayPopularNews(
                  id: item.id ?? 0,
                  viewCount: item.viewCount ?? 0,
                  coverImg: item.image ?? '',
                  title: item.title ?? '',
                  channelSlug: item.channelSlug ?? '',
                  logo: item.channelLogo ?? '',
                  publisher: item.channelName ?? '',
                  time: item.publishDate ?? '',
                  slug: item.slug ?? '', postType:  item.type, videoThumb: item.videoThumb, video: item.video,

                ),
              ),
            );
          },
        );
      },
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