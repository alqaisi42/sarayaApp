import 'package:flutter_bloc/flutter_bloc.dart';


import '../../Model/follow_and_unfollow_model.dart';
import '../../config/api_routes.dart';

import '../blocRepository/post_api_repo.dart';
import 'follow_and_unfollow_event.dart';
import 'follow_and_unfollow_state.dart';



class FollowandunfollowBloc extends Bloc<FollowAndunfollowEvent, FollowAndunfollowState> {
  final PostapiRepo<FollowAndUnfollowResponse> _postapiRepo;
  List<FollowAndUnfollowResponse>? cachedFollowAndunfollow;
 late bool statusRes ;

  FollowandunfollowBloc()
      : _postapiRepo = PostapiRepo<FollowAndUnfollowResponse>(fromJson: FollowAndUnfollowResponse.fromJson, isToken: true),
        super(FollowAndunfollowInitialState()) {
    on<PostFollowAndunfollow>(_onPostFollowAndunfollow);
  }

  Future<void> _onPostFollowAndunfollow(PostFollowAndunfollow event, Emitter<FollowAndunfollowState> emit) async {
    emit(FollowAndunfollowLoadingState());

    try {
      final result = await _postapiRepo.postData(
        "$followAndUnfolloeUrl/${event.slug}",
        slug: event.slug,
      );
      cachedFollowAndunfollow = result;
      emit(FollowAndunfollowSuccessState(followAndFollowData: result));
    } catch (e) {
      emit(FollowAndunfollowErrorState(errorMessage: e.toString()));
    }
  }

}

