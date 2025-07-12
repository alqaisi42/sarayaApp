


import 'package:flutter_bloc/flutter_bloc.dart';


import '../../Model/comment_post_model.dart';

import '../../config/api_routes.dart';

import '../blocRepository/post_api_repo.dart';
import 'post_comments_event.dart';
import 'post_comments_state.dart';

class CommentsPostBloc extends Bloc<CommentsPostEvent, CommentsPostState> {
  final PostapiRepo<CommentPostResponse> _postapiRepo;


  CommentsPostBloc() :
        _postapiRepo = PostapiRepo<CommentPostResponse>(fromJson: CommentPostResponse.fromJson, isToken: true),
        super(CommentsPostInitialState()) {
    on<PostComments>(_onPostComments);
  }

  Future<void> _onPostComments(PostComments event, Emitter<CommentsPostState> emit) async {
    emit(CommentsPostLoadingState());
    try {
      final result = await _postapiRepo.postData(
        postCommentUrl,
        comments: event.postComments,
        postID: event.currentPostId.toString(),
        replyId: event.replyPostId.toString(),
      );
      emit(CommentsPostSuccessState(commentsPostList: result));
    } catch (e) {
      emit(CommentsPostErrorState(errorMessage: e.toString()));
    }
  }
}
