

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Model/edit_comment_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/post_api_repo.dart';
import '../commentsReplyBloc/comments_reply_bloc.dart';
import '../commentsReplyBloc/comments_reply_event.dart';
import '../getCommentsBloc/get_comments_bloc.dart';
import '../getCommentsBloc/get_comments_event.dart';
import 'edit_comment_event.dart';
import 'edit_comment_state.dart';


class EditCommentBloc extends Bloc<EditCommentEvent, EditCommentState> {
  final PostapiRepo<EditCommentResponse> _postapiRepo;

  EditCommentBloc(): _postapiRepo = PostapiRepo<EditCommentResponse>(fromJson: EditCommentResponse.fromJson, isToken: true,),
        super(EditCommentInitialState()) {on<PostEditComment>(_postEditComment);
  }

  Future<void> _postEditComment(PostEditComment event, Emitter<EditCommentState> emit) async {
    emit(EditCommentInitialState());
    try {
      final result = await _postapiRepo.postData(
        editCommentUrl,
        id: event.commentId.toString(),
        comments: event.userComment
      );


      if(event.cmtType == "parentComment") {
        if (event.context.mounted) {
          event.context.read<GetCommentsBloc>().add(
              FetchGetComments(getPostId: event.postId, context: event.context));
        }
      } else {
        if (event.context.mounted) {
          event.context.read<GetCommentsBloc>().add(
              FetchGetComments(getPostId: event.postId, context: event.context));
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

      emit(EditCommentSuccessState(editCommentData: result));
    } catch (e) {
      emit(EditCommentErrorState(errorMessage: e.toString()));
    }
  }
}
