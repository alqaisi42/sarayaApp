import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/Model/detail_page_model.dart';
import 'package:newsapp/bloc/bookmark/bookmark_article_bloc.dart';

import '../../config/api_routes.dart';


import '../blocRepository/get_api_repo.dart';
import '../commentsCountBloc/comment_count_bloc.dart';
import '../commentsCountBloc/comment_count_event.dart';
import 'details_page_event.dart';
import 'details_page_state.dart';



class DetailspageBloc extends Bloc<FetchDetailspage,DetailspageState>{
  DetailspageBloc() : super(DetailspageInitialState()){
    on<FetchDetailspage>(onFetchNewsTopic);
  }

  Future<void> onFetchNewsTopic(FetchDetailspage event, Emitter<DetailspageState> emit) async {
    emit(DetailspageLoadingState());

    try{
        final apiRepo = GetapiRepo(url: "$detailPageUrl${event.slug}/${event.deviceid}/${event.fcmToken}", fromJson: DetailPageResponse.fromJson, isToken: true);

        final List<DetailPageResponse> detailPageData = await apiRepo.getData();
        final Map<String, int> commentCounts = {};



        commentCounts[detailPageData[0].data!.slug!] = detailPageData[0].data!.comment!;

        if(event.context.mounted){
          event.context.read<CommentCountBloc>().add(InitializeCommentCounts(initialCounts: commentCounts));
        }

        if(detailPageData[0].data?.isFavorite! == 1){
         if(event.context.mounted){
           event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: event.slug!));
         }
        } else{
          if(event.context.mounted){
            event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: event.slug!));
          }
        }
        emit(DetailspageSuccessState(detailPage: detailPageData));
      }catch(e){
        emit(DetailspageErrorState(errorMessage: e.toString()));
      }

  }
}

