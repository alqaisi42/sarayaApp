



import 'package:flutter_bloc/flutter_bloc.dart';



import '../../Model/multi_lang_post_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/post_api_repo.dart';
import 'multi_news_post_event.dart';
import 'multi_news_post_state.dart';



class MultiNewsPostBloc extends Bloc<MultiNewsPostEvent, MultiNewsPostState> {
  final PostapiRepo<MultiLangPostModel> postapiRepo;

  MultiNewsPostBloc()
      : postapiRepo = PostapiRepo<MultiLangPostModel>(
    fromJson: (json) => MultiLangPostModel.fromJson(json),
    isToken: true,
  ),
        super(MultiNewsPostInitialState()) {
    on<PostNewsLanguageId>(_onPostNewsLanguageId);
  }

  Future<void> _onPostNewsLanguageId(PostNewsLanguageId event, Emitter<MultiNewsPostState> emit) async {
    emit(MultiNewsPostLoadingState());
    try {
      final response = await postapiRepo.postData(getPostsLanguageUrl, newsLanguageId : event.newsLanguageId);



      emit(MultiNewsPostSuccessState(newsLanguageIdData: response));
    } catch (e) {
      emit(MultiNewsPostErrorState(errorMessage: e.toString()));
    }
  }
}
