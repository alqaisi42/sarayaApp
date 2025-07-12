import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/constants.dart';


import '../../../bloc/popularNewsAllBloc/popular_newsall_bloc.dart';
import '../../../bloc/popularNewsAllBloc/popular_newsall_event.dart';
import '../../../bloc/popularNewsAllBloc/popular_newsall_state.dart';
import '../../../config/googleAdMob/banner_ad.dart';
import '../../../config/helper/empty_state_ui.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';


import '../../../utils/widgets/custome_dispay_newscard.dart';
import '../../../l10n/app_localizations.dart';
class PopularNewsall extends StatefulWidget {
  const PopularNewsall({super.key});

  @override
  State<PopularNewsall> createState() => _PopularNewsallState();
}


class _PopularNewsallState extends State<PopularNewsall> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PopularNewsAllBloc>().add(FetchPopularNewsAll(initialValue: 1, context: context));

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<PopularNewsAllBloc>().add(FetchMorePopularNewsAll(context: context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.popularNews,style: TextStyle(fontFamily: fontType),),
      ),
      body: RefreshIndicator(
        color: AppColors().primaryColor,
        onRefresh: () async {
          context.read<PopularNewsAllBloc>().add(FetchPopularNewsAll(refreshIndicator: true, context: context));
        },
        child: BlocBuilder<PopularNewsAllBloc, PopularNewsAllState>(
          builder: (context, state) {
            if (state is PopularNewsAllInitialState ||
                (state is PopularNewsAllLoadingState && state.popularNewsAll.isEmpty)) {
              return _buildLoadingShimmer();
            } else if (state is PopularNewsAllErrorState && context.read<PopularNewsAllBloc>().allNews.isEmpty) {
              return Center(child: Text('${AppLocalizations.of(context)!.error}: ${state.errorMessage}',style: TextStyle(fontFamily: fontType),));
            } else {
              return _buildNewsList(state);
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

  Widget _buildNewsList(PopularNewsAllState state) {
    final allData = context.read<PopularNewsAllBloc>().allNews.expand((response) => response.data ?? []).toList();


    if(allData.isEmpty){
      return EmptyStateWidget(
        title: '${AppLocalizations.of(context)!.popularNews} ${AppLocalizations.of(context)!.isCurrentlyEmpty}',
        customImage: Image.asset(
          'assets/img/empty.png',
          width: MediaQueryHelper.screenWidth(context) * 0.65,
        ),
          message:AppLocalizations.of(context)!.noContentAvailable,
        buttonText:AppLocalizations.of(context)!.retry,
        onButtonPressed: () {
          context.read<PopularNewsAllBloc>().add(FetchPopularNewsAll(initialValue: 1, context: context));
        },

      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: allData.length + 1,
      itemBuilder: (context, index) {
        if (index == allData.length) {
          if (state is PopularNewsAllLoadingMoreState) {
            return  Center(child: CircularProgressIndicator(color: AppColors().primaryColor));
          } else {
            return const SizedBox.shrink();
          }
        }
        if ( context.read<PopularNewsAllBloc>().showAds == false) {
          if (index > 0 && index % 4 == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: AdBannerWidget(),
            );
          }
        }
        final dataIndex = index - (index ~/ 4);

        if (dataIndex >= allData.length) return const SizedBox.shrink();


        final item = allData[index];
        return GestureDetector(
          onTap: () async {
            checkLimitAndNavigate(context, item.slug);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQueryHelper.screenWidth(context) * 0.03,
            ),
            child: DisplayPopularNews(
              id: item.id ?? 0,
              viewCount: item.viewCount ?? 0,
              coverImg: item.image ?? '',
              title: item.title ?? '',
              channelSlug: item.channelSlug ?? '',
              logo: item.channelLogo ?? '',
              publisher: item.channelName ?? '',
              time: item.publishDate ?? '',
              slug: item.slug ?? '',
              postType: item.type ?? "", videoThumb: item.videoThumb ?? "", video: item.video ?? "",
            ),
          ),
        );
      },
    );
  }
}

