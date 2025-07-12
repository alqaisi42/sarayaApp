
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../Model/comment_reply_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/get_api_repo.dart';
import 'comments_reply_event.dart';
import 'comments_reply_state.dart';
class CommentsReplyBloc extends Bloc<CommentReplyEvent, CommentsReplyState> {
  final int perPage = 5;
  Map<String, List<CommentReplyResponse>> repliesMap = {};

  CommentsReplyBloc() : super(CommentsReplyInitialState()) {
    on<FetchCommentsReply>(_onFetchCommentsReply);
    on<CommentReplyInitial>(_onCommentReplyInitial);
  }

  Future<void> _onFetchCommentsReply(
      FetchCommentsReply event,
      Emitter<CommentsReplyState> emit,
      ) async {
    try {
      if (event.page == 1) {
        emit(CommentsReplyLoadingState(parentCommentId: event.parentCommentId));
        repliesMap[event.parentCommentId] = [];
      }

      final apiRepo = GetapiRepo(
        url: "$getCommentReplyUrl/${event.postId}/${event.parentCommentId}?page=${event.page}&per_page=$perPage",
        fromJson: CommentReplyResponse.fromJson,
        isToken: true,
      );

      final List<CommentReplyResponse> newReplies = await apiRepo.getData();

      if (newReplies.isNotEmpty) {
        if (event.page == 1) {
          repliesMap[event.parentCommentId] = newReplies;
        } else {
          if (repliesMap[event.parentCommentId]?.isNotEmpty == true &&
              newReplies.isNotEmpty) {
            final existingResponse = repliesMap[event.parentCommentId]![0];
            final newResponse = newReplies[0];

            final List<Data> mergedData = [
              ...(existingResponse.data ?? []),
              ...(newResponse.data ?? [])
            ];

            final updatedResponse = CommentReplyResponse(
              data: mergedData,);
            repliesMap[event.parentCommentId] = [updatedResponse];
          }
        }

        final currentPageDataLength = newReplies[0].data?.length ?? 0;

        emit(CommentsReplySuccessState(
          commentReplyData: repliesMap[event.parentCommentId] ?? [],
          currentPage: event.page,
          hasMorePages: currentPageDataLength >= perPage,
          parentCommentId: event.parentCommentId,
        ));
      } else {
        emit(CommentsReplySuccessState(
          commentReplyData: repliesMap[event.parentCommentId] ?? [],
          currentPage: event.page,
          hasMorePages: false,
          parentCommentId: event.parentCommentId,
        ));
      }
    } catch (e) {

      emit(CommentsReplyErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onCommentReplyInitial(CommentReplyInitial event, Emitter<CommentsReplyState> emit) async {
    emit(CommentsReplyInitialState());
  }
}