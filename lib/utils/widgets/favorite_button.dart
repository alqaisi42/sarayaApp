
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:newsapp/bloc/bookmark/bookmark_article_bloc.dart';
import 'package:newsapp/config/colors.dart';

import 'package:share_plus/share_plus.dart';
import '../../Model/auth model/auth_response_model.dart';
import '../../config/constants.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';

import '../../l10n/app_localizations.dart';

Future<bool> isLogged() async {
  AuthResponse? fetchedToken = await HiveStorage().getToken();
  if (fetchedToken == null) {
    return false;
  }
  return true;
}

class FavoriteButton extends StatefulWidget {
  final String postSlug;
  final String postImg;

  const FavoriteButton(
      {super.key, required this.postSlug, required this.postImg});

  @override
  FavoriteButtonState createState() => FavoriteButtonState();
}

class FavoriteButtonState extends State<FavoriteButton> {
  @override
  void initState() {
    super.initState();

    isLogged();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: BlocBuilder<BookmarkArticleBloc, BookmarkArticleState>(
                builder: (context, state) {
                  state as BookmarkArticleAll;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(
                          state.slugs.contains(widget.postSlug)
                              ? HeroiconsSolid.bookmark
                              : HeroiconsOutline.bookmark,
                          color: state.slugs.contains(widget.postSlug)
                              ? AppColors().primaryColor
                              : Colors.grey.shade500,
                        ),
                        title: Text(state.slugs.contains(widget.postSlug,)
                            ? AppLocalizations.of(context)!.removeBookmark
                            : AppLocalizations.of(context)!.bookmarkPost,style: TextStyle(fontFamily: fontType),),
                        onTap: () async {
                          if (state.slugs.contains(widget.postSlug)) {
                            context.read<BookmarkArticleBloc>().add(
                                BookmarkArticleRemove(
                                    context: context,
                                    slug: widget.postSlug,
                                    slugType: "bookmark"));
                          } else {
                            context.read<BookmarkArticleBloc>().add(
                                BookmarkArticleAdd(
                                    slug: widget.postSlug,
                                    context: context,
                                    slugType: "bookmark"));
                          }
                          Navigator.pop(context);
                          return;
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.share,
                          color: Colors.green,
                        ),
                        title: Text(AppLocalizations.of(context)!.share,style: TextStyle(fontFamily: fontType),),
                        onTap: () {
                          final String appLink = '$baseUrl/posts/${widget.postSlug}';
                          Share.share(appLink,);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
      child:
          Icon(HeroiconsOutline.ellipsisVertical, color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600]),
    );
  }
}
