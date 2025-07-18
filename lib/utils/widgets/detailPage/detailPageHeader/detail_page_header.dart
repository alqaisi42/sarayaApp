


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../../../../bloc/bookmark/bookmark_article_bloc.dart';
import '../../../../config/colors.dart';
import '../translator/translator.dart';


class DetailPageHeader extends StatefulWidget {
  final String slug;


  const DetailPageHeader({
    super.key,
    required this.slug,

  });
  @override
  DetailPageHeaderState createState() => DetailPageHeaderState();
}

class DetailPageHeaderState extends State<DetailPageHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // LanguageSelector(),
        BlocBuilder<BookmarkArticleBloc, BookmarkArticleState>(
          builder: (context, state) {
            state as BookmarkArticleAll;
            return InkWell(
              onTap: () async {
                if (state.slugs.contains(widget.slug)) {
                  context.read<BookmarkArticleBloc>().add(BookmarkArticleRemove(
                      slug: widget.slug,
                      context: context,
                      slugType: "bookmark"));
                } else {
                  context.read<BookmarkArticleBloc>().add(BookmarkArticleAdd(
                      slug: widget.slug,
                      context: context,
                      slugType: "bookmark"));
                }
                setState(() {});
              },
              child: Icon(
                state.slugs.contains(widget.slug)
                    ? HeroiconsSolid.bookmark
                    : HeroiconsOutline.bookmark,
                color: state.slugs.contains(widget.slug)
                    ? AppColors().primaryColor
                    : Colors.white,
              ),
            );
          },
        )
      ],
    );
  }
}