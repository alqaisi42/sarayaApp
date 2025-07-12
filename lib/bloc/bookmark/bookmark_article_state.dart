part of 'bookmark_article_bloc.dart';

sealed class BookmarkArticleState extends Equatable {
  const BookmarkArticleState();
}

final class BookmarkArticleAll extends BookmarkArticleState {

  final List<String> slugs;


  const BookmarkArticleAll({required this.slugs});

  @override
  List<Object> get props => [slugs];
}

