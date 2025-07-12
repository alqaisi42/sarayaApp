

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:newsapp/config/api_routes.dart';


import '../../Model/reactors_user_model.dart';
import '../blocRepository/get_api_repo.dart';

import 'get_react_user_data_event.dart';
import 'get_react_user_data_state.dart';



class GetReactUserDataBloc extends Bloc<GetReactUserDataEvent, GetReactUserDataState> {
  int page = 1;
  bool isLoading = false;
  List<ReactorsUserModel> reactorsDataListArr = [];
  ScrollController scrollController = ScrollController();
  String currentEmojiType = '';
  String slug = '';

  GetReactUserDataBloc() : super(GetReactUserDataInitialState()) {
    scrollController.addListener(_onScroll);
    on<FetchReactUserData>(_onFetchReactUserData);
    on<FetchMoreReactUserData>(_onFetchMoreReactUserData);

  }

  void _onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoading) {
      add(FetchMoreReactUserData());
    }
  }


  Future<void> _onFetchReactUserData(
      FetchReactUserData event, Emitter<GetReactUserDataState> emit) async {
    currentEmojiType = event.emojiType;
    slug = event.slug;

    if (event.initialValue == 1) {
      page = 1;
      reactorsDataListArr.clear();
    }

    if (page == 1) emit(GetReactUserDataLoadingState(reactorsDataListArr));

    try {
      List<ReactorsUserModel> reactors = await GetapiRepo(
        url: "$userReactorsUrl/${event.emojiType}/${event.slug}?page=$page&per_page=15",
        fromJson: ReactorsUserModel.fromJson,
        isToken: true,
      ).getData();



      // Add only if data exists
      if (reactors.isNotEmpty && reactors[0].data != null) {
        reactorsDataListArr.addAll(reactors);
      }else {
        reactorsDataListArr.addAll(reactors);
      }
      page++;


      emit(GetReactUserDataSuccessState(reactorsDataList: reactorsDataListArr));
    } catch (error) {
      emit(GetReactUserDataErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onFetchMoreReactUserData(
      FetchMoreReactUserData event, Emitter<GetReactUserDataState> emit) async {
    if (isLoading) return;

    isLoading = true;
    emit(GetReactUserDataLoadingMoreState(reactorsDataListArr));

    try {
      List<ReactorsUserModel> reactors = await GetapiRepo(
        url: "$userReactorsUrl/$currentEmojiType/$slug?page=$page&per_page=15",
        fromJson: ReactorsUserModel.fromJson,
        isToken: true,
      ).getData();




      if (reactors.isNotEmpty && reactors[0].data != null && reactors[0].data!.isNotEmpty) {

        if (reactorsDataListArr.isNotEmpty && reactorsDataListArr[0].data != null) {
          reactorsDataListArr[0].data!.addAll(reactors[0].data!);
        } else {
          reactorsDataListArr.addAll(reactors);
        }
        page++;

        emit(GetReactUserDataSuccessState(reactorsDataList: reactorsDataListArr));
      } else {
        // No more data to load
        emit(GetReactUserDataSuccessState(reactorsDataList: reactorsDataListArr));

      }
    } catch (error) {

      emit(GetReactUserDataErrorState(errorMessage: error.toString()));
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



