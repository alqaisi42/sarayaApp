import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/Model/slider_model.dart';
import 'package:newsapp/bloc/sliderBloc/slider_event.dart';
import 'package:newsapp/bloc/sliderBloc/slider_state.dart';

import 'package:newsapp/config/api_routes.dart';

import '../blocRepository/get_api_repo.dart';



class SliderBloc extends Bloc<SliderEvent, SliderState> {
  List<BannerPostsResponse>? cachedSlider;

  SliderBloc() : super(SliderInitialState()) {
    on<FetchSlider>(onFetchSlider);
    on<ClearSliderData>(onClearSliderData);
  }

  Future<void> onFetchSlider(FetchSlider event, Emitter<SliderState> emit) async {
    if (event.refreshIndicator || cachedSlider == null || event.reFetch) {

      if(!event.reFetch){
        emit(SliderLoadingState());
      }
      try {
        final apiRepo = GetapiRepo<BannerPostsResponse>(
          url: sliderUrl,
          fromJson: BannerPostsResponse.fromJson, isToken: false,
        );
        final List<BannerPostsResponse> sliderData = await apiRepo.getData();
        cachedSlider = sliderData;

        emit(SliderSuccessState(slider: sliderData));

      } catch (e) {
        emit(SliderErrorState(e.toString()));
      }
    } else {

      emit(SliderSuccessState(slider: cachedSlider!));
    }
  }

  Future<void>  onClearSliderData(ClearSliderData event, Emitter<SliderState> emit) async {
    emit(SliderSuccessState(slider: []));
  }

}












