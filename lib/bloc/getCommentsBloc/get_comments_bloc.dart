import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newsapp/config/api_routes.dart';
import '../../Model/get_comment_model.dart';
import '../blocRepository/get_api_repo.dart';
import '../commentsCountBloc/comment_count_bloc.dart';
import '../commentsCountBloc/comment_count_event.dart';
import 'get_comments_event.dart';
import 'get_comments_state.dart';






class GetCommentsBloc extends Bloc<GetCommentsEvent, GetCommentsState> {
  int page = 1;
  bool isLoading = false;
  List<CommentsGetResponse> commentsDataList = [];
  ScrollController scrollController = ScrollController();
  String postId = '';

  GetCommentsBloc() : super(GetCommentsInitialState()) {
    scrollController.addListener(_onScroll);
    on<FetchGetComments>(_onFetchGetComments);
    on<FetchMoreComments>(_onFetchMoreComments);
  }

  void _onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoading) {
      add(FetchMoreComments());
    }
  }

  Future<void> _onFetchGetComments(FetchGetComments event, Emitter<GetCommentsState> emit) async {
    postId = event.getPostId.toString();
    page = 1;
    commentsDataList = [];



    try {
      List<CommentsGetResponse> comments = await GetapiRepo(
        url: "$getCommentUrl/${event.getPostId}?page=$page&per_page=8",
        fromJson: CommentsGetResponse.fromJson,
        isToken: true,
      ).getData();

      if (comments.isNotEmpty && comments[0].data != null) {
        if(event.context.mounted) {
          event.context.read<CommentCountBloc>().add(
              UpdateCommentCount(
                  slug: event.slug.toString(),
                  apiCommentCount: comments[0].data!.count!.toInt()
              )
          );
        }
        commentsDataList.addAll(comments);
        page++;
      }

      emit(GetCommentsSuccessState(commentsDataList));
    } catch(e) {
      emit(GetCommentsErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchMoreComments(FetchMoreComments event, Emitter<GetCommentsState> emit) async {
    if (isLoading) return;

    isLoading = true;
    emit(GetCommentsLoadingMoreState(commentsDataList));

    try {
      List<CommentsGetResponse> comments = await GetapiRepo(
        url: "$getCommentUrl/$postId?page=$page&per_page=8",
        fromJson: CommentsGetResponse.fromJson,
        isToken: true,
      ).getData();

      if (comments.isNotEmpty && comments[0].data != null && comments[0].data!.comment != null && comments[0].data!.comment!.isNotEmpty) {
        if (commentsDataList.isNotEmpty && commentsDataList[0].data != null && commentsDataList[0].data!.comment != null) {
          commentsDataList[0].data!.comment!.addAll(comments[0].data!.comment!);
        } else {
          commentsDataList.addAll(comments);
        }
        page++;
        emit(GetCommentsSuccessState(commentsDataList));
      } else {
        // No more data to load
        emit(GetCommentsSuccessState(commentsDataList));
      }
    } catch (error) {
      emit(GetCommentsErrorState(errorMessage: error.toString()));
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
