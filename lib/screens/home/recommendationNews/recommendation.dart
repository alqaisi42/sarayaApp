import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


import '../../../bloc/recommendationNewsBloc/recommendation_bloc.dart';
import '../../../bloc/recommendationNewsBloc/recommendation_event.dart';
import '../../../bloc/recommendationNewsBloc/recommendation_state.dart';
import '../../../config/googleAdMob/banner_ad.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';


import '../../../utils/widgets/custome_title.dart';
import '../../../utils/widgets/recommendationdata.dart';
import '../../../l10n/app_localizations.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({super.key});

  @override
  RecommendationUIState createState() => RecommendationUIState();
}



class RecommendationUIState extends State<Recommendation> {

  @override
  void initState() {
    super.initState();

    context.read<RecommendationBloc>().add(FetchRecommendation(context: context));
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendationBloc, RecommendationState>(
      builder: (context, state) {
        if (state is RecommendationLoadingState) {
          return Column(
            children: [
              ShimmerWidget(
                width: MediaQueryHelper.screenWidth(context),
                height: MediaQueryHelper.screenHeight(context) * 0.4,
                margin: EdgeInsets.only(
                    bottom: MediaQueryHelper.screenWidth(context) * 0.04),
              ),
            ],
          );
        } else if (state is RecommendationSuccessState) {
          final recommendationNews = state.recommendationNews[0].data!.take(10).toList();

          if (recommendationNews.isEmpty) {
            return SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: MediaQueryHelper.screenWidth(context) * 0.04,
                  top: MediaQueryHelper.screenHeight(context) * 0.03,
                  right: MediaQueryHelper.screenWidth(context) * 0.04,
                ),
                child: CustomeTitle(
                  title: AppLocalizations.of(context)!.recommendation,
                  title2: AppLocalizations.of(context)!.seeAll,
                  onTap: () {
                    GoRouter.of(context).push("/recommedationAll");
                  },
                ),
              ),
              SizedBox(
                height: MediaQueryHelper.screenHeight(context) * 0.01,
              ),
              SizedBox(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: recommendationNews.length + (recommendationNews.length ~/ 4),
                  itemBuilder: (context, index) {
                    if(state.recommendationNews[0].isAdsFree == false){
                      if (index > 0 && index % 4 == 0) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: AdBannerWidget(),
                        );
                      }
                    }
                    final dataIndex = index - (index ~/ 4);

                    if (dataIndex >= recommendationNews.length) return const SizedBox.shrink();

                    final item = recommendationNews[dataIndex];
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
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }








}