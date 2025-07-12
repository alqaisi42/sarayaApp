import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newsapp/config/colors.dart';

import '../../../bloc/searchResultBloc/search_result_bloc.dart';
import '../../../bloc/searchResultBloc/search_result_event.dart';
import '../../../bloc/searchResultBloc/search_result_state.dart';


import '../../../config/helper/helper_functions.dart';
import '../../../utils/widgets/custome_dispay_newscard.dart';


class SearchResultListWidget extends StatefulWidget {
  const SearchResultListWidget({super.key});

  @override
  State<SearchResultListWidget> createState() => _SearchResultListWidgetState();
}

class _SearchResultListWidgetState extends State<SearchResultListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<SearchResultBloc>().add(FetchMoreSearchResult(context: context));
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<SearchResultBloc, SearchResultState>(
        builder: (context, state) {
          if (state is SearchResultLoadingState && state.searchResultData.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: AppColors().primaryColor),
            );
          }
          if (state is SearchResultSuccessState ||
              state is SearchResultLoadingMoreState ||
              (state is SearchResultLoadingState && state.searchResultData.isNotEmpty)) {
            final data = state is SearchResultSuccessState
                ? state.searchResultData
                : state is SearchResultLoadingMoreState
                ? state.searchResultData
                : (state as SearchResultLoadingState).searchResultData;


            final allData = data.expand((response) => response.data ?? []).toList();

            return ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              controller: _scrollController,
              itemCount: allData.length + 1,
              itemBuilder: (context, index) {
                if (index == allData.length) {
                  return state is SearchResultLoadingMoreState
                      ? Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors().primaryColor),
                    ),
                  )
                      : SizedBox();
                }

                final item = allData[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04,
                    top: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      checkLimitAndNavigate(context, item.slug);
                    },
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
                      postType: item.type ?? "",
                      videoThumb: item.videoThumb ?? "",
                      video: item.video ?? "",
                    ),
                  ),
                );
              },
            );
          }

          if (state is SearchResultErrorState) {
            return Center(child: Text(state.errorMessage));
          }

          return const SizedBox();
        },
      ),
    );
  }

// Widget build(BuildContext context) {
  //   return Expanded(
  //     child: BlocBuilder<SearchResultBloc, SearchResultState>(
  //       builder: (context, state) {
  //         if (state is SearchResultLoadingState && state.searchResultData.isEmpty) {
  //           return  Center(
  //             child: CircularProgressIndicator(color: AppColors.primaryColor),
  //           );
  //         }
  //         if (state is SearchResultSuccessState ||
  //             state is SearchResultLoadingMoreState ||
  //             (state is SearchResultLoadingState && state.searchResultData.isNotEmpty)) {
  //           final data = state is SearchResultSuccessState
  //               ? state.searchResultData
  //               : state is SearchResultLoadingMoreState
  //               ? state.searchResultData
  //               : (state as SearchResultLoadingState).searchResultData;
  //
  //           if (data.isEmpty) {
  //             return  Center(child: Text(AppLocalizations.of(context)!.noResultsFound));
  //           }
  //
  //           final allData = data.expand((response) => response.data ?? []).toList();
  //
  //           return ListView.builder(
  //             keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
  //             controller: _scrollController,
  //             itemCount: allData.length + 1,
  //             itemBuilder: (context, index) {
  //               if (index == allData.length) {
  //                 return state is SearchResultLoadingMoreState
  //                     ?  Padding(
  //                   padding: EdgeInsets.all(16.0),
  //                   child: Center(
  //                     child: CircularProgressIndicator(color: AppColors.primaryColor),
  //                   ),
  //                 )
  //                     :  SizedBox();
  //               }
  //
  //               final item = allData[index];
  //               return Padding(
  //                 padding: EdgeInsets.only(
  //                   left: MediaQuery.of(context).size.width * 0.04,
  //                   right: MediaQuery.of(context).size.width * 0.04,
  //                   top: MediaQuery.of(context).size.height * 0.01,
  //                 ),
  //                 child: GestureDetector(
  //                   onTap: () {
  //
  //                     GoRouter.of(context).push("/detailpage/${item.slug}");
  //                   },
  //                   child: DisplayPopularNews(
  //                     id: item.id ?? 0,
  //                     viewCount: item.viewCount ?? 0,
  //                     coverImg: item.image ?? '',
  //                     title: item.title ?? '',
  //                     channelSlug: item.channelSlug ?? '',
  //                     logo: item.channelLogo ?? '',
  //                     publisher: item.channelName ?? '',
  //                     time: item.publishDate ?? '',
  //                     slug: item.slug ?? '',
  //                     postType: item.type ?? "", videoThumb: item.videoThumb ?? "", video: item.video ?? "",
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         }
  //
  //         if (state is SearchResultErrorState) {
  //           return Center(child: Text(state.errorMessage));
  //         }
  //
  //         return const SizedBox();
  //       },
  //     ),
  //   );
  // }
}