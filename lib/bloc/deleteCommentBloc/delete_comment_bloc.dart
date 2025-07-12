



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/deleteCommentBloc/delete_comment_event.dart';
import 'package:newsapp/bloc/deleteCommentBloc/delete_comment_state.dart';

import '../../Model/delete_comment_model.dart';
import '../../config/api_baseurl.dart';
import '../../config/api_routes.dart';
import '../blocRepository/post_api_repo.dart';
import '../commentsReplyBloc/comments_reply_bloc.dart';
import '../commentsReplyBloc/comments_reply_event.dart';
import '../getCommentsBloc/get_comments_bloc.dart';
import '../getCommentsBloc/get_comments_event.dart';



class DeleteCommentBloc extends Bloc<DeleteCommentEvent, DeleteCommentState> {
  final PostapiRepo<DeleteCommentResponse> postapiRepo;
  final ApiBaseHelper apiBaseHelper;

  DeleteCommentBloc()
      : postapiRepo = PostapiRepo<DeleteCommentResponse>(
    fromJson: DeleteCommentResponse.fromJson,
    isToken: true,
  ),
        apiBaseHelper = ApiBaseHelper(),
        super(DeleteCommentInitialState()) {
    on<PostDeleteComment>(_postDeleteComment);
  }

  Future<void> _postDeleteComment(PostDeleteComment event, Emitter<DeleteCommentState> emit) async {
    try {
      final result = await apiBaseHelper.deleteAPICall(
          "$deleteCommentUrl/${event.commentId}",
          {},
          true
      );



      if(event.commentType == "parentComment"){
        if(event.context.mounted){
          event.context.read<GetCommentsBloc>().add(FetchGetComments(getPostId: event.postId, context: event.context));
        }
      } else {
        if(event.context.mounted){
          event.context.read<GetCommentsBloc>().add(FetchGetComments(getPostId: event.postId, context: event.context));
        }
        if(event.context.mounted){
          event.context.read<CommentsReplyBloc>().add(
            FetchCommentsReply(
              postId: event.postId,
              parentCommentId: event.commentId.toString(),
              page: 1,
            ),
          );
        }

      }



      emit(DeleteCommentSuccessState(commentDeleteData: result));
    } catch (e) {
      emit(DeleteCommentErrorState(errorMessage: e.toString()));
    }
  }
}