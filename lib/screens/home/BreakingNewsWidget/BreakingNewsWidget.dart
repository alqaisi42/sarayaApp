import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../l10n/app_localizations.dart';
import 'BreakingNewsBloc.dart';
import 'BreakingNewsState.dart';
import 'news_model.dart';

class BreakingNewsWidget extends StatelessWidget {
  const BreakingNewsWidget({super.key});

  String formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat.yMMMMd().format(date);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BreakingNewsBloc, BreakingNewsState>(
      builder: (context, state) {
        if (state is BreakingNewsLoading) {
          return _buildLoadingPlaceholder();
        } else if (state is BreakingNewsSuccess && state.breakingNews.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.breakingNews,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 18
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/breakingNews'),
                      child: Text(
                        AppLocalizations.of(context)!.viewMore,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: state.breakingNews.length,
                    itemBuilder: (context, index) {
                      final NewsModel news = state.breakingNews[index];
                      return buildNewsCard(context, news);
                    }                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }


  Widget buildNewsCard(BuildContext context, NewsModel news) {
    return GestureDetector(
      onTap: () => context.push('/post/${news.slug}'),
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: NetworkImage(news.image ?? ''),
            fit: BoxFit.cover,
          ),
        ),
          child: Stack(
            children: [
              // 🖼 Background image with dark overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(news.image ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.75),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 🔴 Urgent badge (Top-left)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.urgent,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),



              // 📰 Title (Center-left)
              Positioned(
                left: 16,
                right: 16,
                bottom: 60,
                child: Text(
                  news.title ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // 📊 Metadata (Bottom)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'USA Today',
                          style: const TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '4h ago',
                          style: const TextStyle(fontSize: 11, color: Colors.white60),
                        ),
                        const SizedBox(width: 6),
                        const Text('•', style: TextStyle(color: Colors.white38)),
                        const SizedBox(width: 6),
                        Text(
                          '5 min read',
                          style: const TextStyle(fontSize: 11, color: Colors.white60),
                        ),
                        // const SizedBox(width: 6),
                        // const Text('•', style: TextStyle(color: Colors.white38)),
                        // const SizedBox(width: 6),
                        // Text(
                        //   '${news.upvotes ?? 54} upvote',
                        //   style: const TextStyle(fontSize: 11, color: Colors.white60),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }


  Widget _buildLoadingPlaceholder() {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 140, width: double.infinity, color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(height: 16, width: 200, color: Colors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(height: 14, width: 100, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );

        },
      ),

    );

  }
}
