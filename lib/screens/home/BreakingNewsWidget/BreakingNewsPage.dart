import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/config/colors.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import 'package:newsapp/utils/widgets/no_internet_screen.dart';
import '../../../utils/widgets/custome_dispay_newscard.dart';
import '../../../config/check_internet.dart';
import '../../../config/helper/empty_state_ui.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';
import '../../../config/constants.dart';
import 'BreakingNewsBloc.dart';
import 'BreakingNewsEvent.dart';
import 'BreakingNewsState.dart';

class BreakingNewsPage extends StatefulWidget {
  const BreakingNewsPage({super.key});

  @override
  State<BreakingNewsPage> createState() => _BreakingNewsPageState();
}

class _BreakingNewsPageState extends State<BreakingNewsPage> {
  final ScrollController _scrollController = ScrollController();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  List<ConnectivityResult> _connectionStatus = [];

  @override
  void initState() {
    super.initState();

    CheckInternet.initConnectivity().then((results) {
      if (results.isNotEmpty) {
        setState(() => _connectionStatus = results);
      }
    });

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty) {
        CheckInternet.updateConnectionStatus(results).then((value) {
          setState(() {
            _connectionStatus = value;
            _fetchBreakingNews();
          });
        });
      }
    });

    _fetchBreakingNews();
  }

  void _fetchBreakingNews() {
    context.read<BreakingNewsBloc>().add(FetchBreakingNews(context: context));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _refreshContent() async {
    _fetchBreakingNews();
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus.contains(connectivityCheck)
        ? const NoInternetScreen()
        : Scaffold(
      appBar: AppBar(
        title: Text(
          'Breaking News',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshContent,
        color: AppColors().primaryColor,
        child: BlocBuilder<BreakingNewsBloc, BreakingNewsState>(
          builder: (context, state) {
            if (state is BreakingNewsLoading) {
              return _buildLoadingShimmer(context);
            } else if (state is BreakingNewsSuccess) {
              if (state.breakingNews.isEmpty) {
                return EmptyStateWidget(
                  title: AppLocalizations.of(context)!.noDataAvailable,
                  buttonText: AppLocalizations.of(context)!.retry,
                  onButtonPressed: _fetchBreakingNews,
                  customImage: Image.asset('assets/img/empty.png'),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: state.breakingNews.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  final news = state.breakingNews[index];
                  return GestureDetector(
                    onTap: () => checkLimitAndNavigate(context, news.slug ?? ''),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DisplayPopularNews(
                        id: news.id ?? 0,
                        viewCount: news.viewCount ?? 0,
                        coverImg: news.image ?? '',
                        title: news.title ?? '',
                        channelSlug: news.channelSlug ?? '',
                        logo: news.channelLogo ?? '',
                        publisher: news.channelName ?? '',
                        time: news.pubDate ?? '',
                        slug: news.slug ?? '',
                        postType: news.type ?? '',
                        videoThumb: news.videoThumb ?? '',
                        video: news.video ?? '',
                      ),
                    ),
                  );
                },
              );
            } else if (state is BreakingNewsError) {
              return Center(child: Text(state.message));
            }

            return Center(child: Text(AppLocalizations.of(context)!.noDataAvailable));
          },
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.all(12),
      itemBuilder: (_, __) => ShimmerWidget(
        width: double.infinity,
        height: 100,
        margin: const EdgeInsets.only(bottom: 16),
      ),
    );
  }
}
