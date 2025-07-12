part of 'bookmark_article_bloc.dart';

abstract class BookmarkArticleEvent extends Equatable {
  const BookmarkArticleEvent();
}


 class BookmarkArticleSoftAdd extends BookmarkArticleEvent {

  final String slug;

  const BookmarkArticleSoftAdd({required this.slug});

  @override
  List<Object?> get props => throw UnimplementedError();
}


 class BookmarkArticleAdd extends BookmarkArticleEvent {

  final String slug;
  final BuildContext context;
  final String? slugType;
  const BookmarkArticleAdd({required this.slug, required this.context,required this.slugType});

  @override
  List<Object?> get props => throw UnimplementedError();
}

 class BookmarkArticleRemove extends BookmarkArticleEvent {

  final String slug;
  final BuildContext context;
  final String? slugType;
  const BookmarkArticleRemove({required this.slug, required this.context,required this.slugType});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class BookmarkArticleSoftRemove extends BookmarkArticleEvent {

 final String slug;

 const BookmarkArticleSoftRemove({required this.slug});

 @override
 List<Object?> get props => throw UnimplementedError();
}

class EmptyBookmarkDetails extends BookmarkArticleEvent{

 @override
 List<Object?> get props => throw UnimplementedError();
}


