// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/config/constants.dart';


import 'package:newsapp/utils/widgets/custome_title.dart';

import '../../../bloc/popularHomeNewsBloc/popular_news_home_bloc.dart';
import '../../../bloc/popularHomeNewsBloc/popular_news_home_event.dart';
import '../../../bloc/popularHomeNewsBloc/popular_news_home_state.dart';
import '../../../config/googleAdMob/banner_ad.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/hiveLocalStorage/hive_storage.dart';
import '../../../config/shimmer.dart';


import '../../../utils/widgets/custome_dispay_newscard.dart';
import '../../../l10n/app_localizations.dart';


class PopularNews extends StatefulWidget {
  const PopularNews({super.key});

  @override
  State<PopularNews> createState() => _PopularNewsState();
}

class _PopularNewsState extends State<PopularNews> {
  @override
  void initState() {
    context.read<PopularBloc>().add(FetchPopular(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularBloc, PopularState>(
      builder: (context, state) {
        if (state is PopularSuccessState &&
            state.popularNews.isNotEmpty &&
            state.popularNews[0].data!.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.only(
              left: MediaQueryHelper.screenWidth(context) * 0.04,
              right: MediaQueryHelper.screenWidth(context) * 0.04,
              top: MediaQueryHelper.screenHeight(context) * 0.03,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQueryHelper.screenHeight(context) * 0.01,
                  ),
                  child: CustomeTitle(
                    title: AppLocalizations.of(context)!.popularNews,
                    title2: AppLocalizations.of(context)!.seeAll,
                    onTap: () {
                      GoRouter.of(context).push("/popularNewsAll");
                    },
                  ),
                ),
                SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
                Column(
                  children: List.generate(
                    state.popularNews[0].data!.length > 5
                        ? 5
                        : state.popularNews[0].data!.length,
                    (index) {
                      final item = state.popularNews[0].data![index];
                      final hiveStorage = HiveStorage();
                      hiveStorage.setAdFreeStatus(state.popularNews[0].isAdsFree ?? false);

                      if (state.popularNews[0].isAdsFree == false) {
                        if (index > 0 && index % 4 == 0) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: AdBannerWidget(),
                          );
                        }
                      }

                      final dataIndex = index - (index ~/ 4);

                      if (dataIndex >= state.popularNews[0].data!.length) {
                        return  SizedBox.shrink();
                      }
                      return GestureDetector(
                        onTap: () async {
                          final slug = item.slug ?? "";
                          checkLimitAndNavigate(context, slug);
                          },

                        child: DisplayPopularNews(
                          id: item.id ?? 0,
                          viewCount: item.viewCount ?? 0,
                          coverImg: item.image ?? "",
                          title: item.title ?? '',
                          channelSlug: item.channelSlug ?? '',
                          logo: item.channelLogo ?? '',
                          publisher: item.channelName ?? '',
                          time: item.publishDate ?? '',
                          slug: item.slug ?? '',
                          postType: item.type ?? "",
                          videoThumb: item.videoThumb ?? "",
                          video: item.video ?? "",
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is PopularLoadingState) {
          return Column(
            children: [
              ShimmerWidget(
                width: MediaQueryHelper.screenWidth(context),
                height: MediaQueryHelper.screenHeight(context) * 0.1,
                margin: EdgeInsets.only(
                  bottom: MediaQueryHelper.screenWidth(context) * 0.04,
                ),
              ),
              ShimmerWidget(
                width: MediaQueryHelper.screenWidth(context),
                height: MediaQueryHelper.screenHeight(context) * 0.1,
                margin: EdgeInsets.only(
                  bottom: MediaQueryHelper.screenWidth(context) * 0.04,
                ),
              ),
              ShimmerWidget(
                width: MediaQueryHelper.screenWidth(context),
                height: MediaQueryHelper.screenHeight(context) * 0.1,
              ),
            ],
          );
        } else if (state is PopularErrorState) {
          return Center(
            child: Text(
              state.errorMessage,
              style: TextStyle(fontFamily: fontType),
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
