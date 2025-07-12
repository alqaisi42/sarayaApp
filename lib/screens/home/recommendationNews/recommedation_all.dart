

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';

import '../../../bloc/recommendationNewAllBloc/recommendation_newsall_state.dart';
import '../../../bloc/recommendationNewAllBloc/recommendation_newsall_bloc.dart';
import '../../../bloc/recommendationNewAllBloc/recommendation_newsall_event.dart';
import '../../../config/check_internet.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../config/googleAdMob/banner_ad.dart';
import '../../../config/helper/empty_state_ui.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';

import '../../../utils/widgets/no_internet_screen.dart';
import '../../../utils/widgets/recommendationdata.dart';


class RecommendationAll extends StatefulWidget {
  const RecommendationAll({super.key});

  @override
  State<RecommendationAll> createState() => _RecommendationAllState();
}

class _RecommendationAllState extends State<RecommendationAll> {
  final ScrollController _scrollController = ScrollController();
  List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  late  StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<RecommendationAllBloc>().add(FetchRecommendationAll(initialValue: 1, context: context));


    CheckInternet.initConnectivity().then((List<ConnectivityResult> results) {
      if (mounted && results.isNotEmpty) {
        setState(() {
          _connectionStatus = results;
        });
      }
    });


    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (mounted) {
        CheckInternet.updateConnectionStatus(results).then((value) {
          setState(() {
            _connectionStatus = value;
            context
                .read<RecommendationAllBloc>()
                .add(FetchRecommendationAll(refreshIndicator: true, context: context));
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();



  }


  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context
          .read<RecommendationAllBloc>()
          .add(FetchMoreRecommendationAll(context: context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return  _connectionStatus.contains(connectivityCheck)
        ?  NoInternetScreen()
        :Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.recommendation,style: TextStyle(fontFamily: fontType),),
      ),
      body: RefreshIndicator(
        color: AppColors().primaryColor,
        onRefresh: () async {
          context
              .read<RecommendationAllBloc>()
              .add(FetchRecommendationAll(refreshIndicator: true, context: context));
        },
        child: BlocBuilder<RecommendationAllBloc, RecommendationAllState>(
          builder: (context, state) {
            if (state is RecommendationAllInitialState ||
                (state is RecommendationAllLoadingState && state.recommendations.isEmpty)) {
              return _buildLoadingShimmer();
            } else if (state is RecommendationAllErrorState &&
                context.read<RecommendationAllBloc>().allRecommendations.isEmpty) {
              return Center(
                  child: Text(
                      '${AppLocalizations.of(context)!.error}: ${state.errorMessage}',style: TextStyle(fontFamily: fontType),));
            } else {
              return _buildRecommendationList(state);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return ShimmerWidget(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
          ),
        );
      },
    );
  }


  Widget _buildLoadingMoreShimmer() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return ShimmerWidget(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
          ),
        );
      },
    );
  }


  Widget _buildRecommendationList(RecommendationAllState state) {
    final allData = context.read<RecommendationAllBloc>().allRecommendations.expand((response) => response.data ?? []).toList();

    if(allData.isEmpty){
      return EmptyStateWidget(
        title: '${AppLocalizations.of(context)!.recommendation} ${AppLocalizations.of(context)!.isCurrentlyEmpty}',
        customImage: Image.asset(
          'assets/img/empty.png',
          width: MediaQueryHelper.screenWidth(context) * 0.65,
        ),
        buttonText:AppLocalizations.of(context)!.retry,
        onButtonPressed: () {
          context.read<RecommendationAllBloc>().add(FetchRecommendationAll(initialValue: 1, context: context));
        },

      );
    }


    return ListView.builder(
      controller: _scrollController,
      itemCount: allData.length + 1,
      itemBuilder: (context, index) {
        if (index == allData.length) {
          return _buildLoadingIndicator();
        }

        if(context.read<RecommendationAllBloc>().showAds == false){
          if (index > 0 && index % 4 == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: AdBannerWidget(),
            );
          }
        }

        final item = allData[index];
        return RecommendationList(
          id: item.id ?? 0,
          viewCount: item.viewCount ?? 0,
          coverImg: item.image ?? '',
          title: item.title ?? '',
          channelSlug: item.channelSlug ?? '',
          logo: item.channelLogo ?? '',
          publisher: item.channelName ?? '',
          time: item.publishDate ?? '',
          slug: item.slug ?? '',
          postType: item.postType ?? "", videoThumb: item.videoThumb ?? "", videoUrl: item.videoUrl ?? "",
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return  SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.3, child: _buildLoadingMoreShimmer());
  }


}
