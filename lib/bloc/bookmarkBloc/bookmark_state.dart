
 import 'package:equatable/equatable.dart';
import 'package:newsapp/Model/bookmark_model.dart';





 abstract class BookmarkState extends Equatable {
   @override
   List<Object?> get props => [];
 }

 class BookmarkInitialState extends BookmarkState {}

 class BookmarkLoadingState extends BookmarkState {
   final List<BookmarkResponse> bookmarkAll;

   BookmarkLoadingState(this.bookmarkAll);

   @override
   List<Object?> get props => [bookmarkAll];
 }

 class BookmarkLoadingMoreState extends BookmarkState {
   final List<BookmarkResponse> bookmarkAll;

   BookmarkLoadingMoreState(this.bookmarkAll);

   @override
   List<Object?> get props => [bookmarkAll];
 }

 class BookmarkSuccessState extends BookmarkState {
   final List<BookmarkResponse> bookmarkAll;

   BookmarkSuccessState({required this.bookmarkAll});

   @override
   List<Object?> get props => [bookmarkAll];
 }

 class BookmarkNoMoreDataState extends BookmarkState {
   final List<BookmarkResponse> bookmarks;

   BookmarkNoMoreDataState({required this.bookmarks});

   @override
   List<Object?> get props => [bookmarks];
 }

 class BookmarkErrorState extends BookmarkState {
   final String errorMessage;

   BookmarkErrorState({required this.errorMessage});

   @override
   List<Object?> get props => [errorMessage];
 }
