



import 'package:flutter_bloc/flutter_bloc.dart';


import '../../Model/multi_langauge_model.dart';

import '../../config/api_routes.dart';
import '../blocRepository/get_api_repo.dart';
import 'multi_lang_event.dart';
import 'multi_lang_state.dart';

  class MultiLangBloc extends Bloc<MultiLangEvent, MultiLangState> {


    MultiLangBloc() : super(MultiLangInitialState()) {
      on<FetchMultiLang>(onFetchMultiLang);
    }

    Future<void> onFetchMultiLang(FetchMultiLang event, Emitter<MultiLangState> emit) async {

        emit(MultiLangLoadingState());
        try {
          final apiRepo = GetapiRepo(
            url: newsLanguagesUrl,
            fromJson: MultiLanguageModel.fromJson,
            isToken: true,
          );

          final List<MultiLanguageModel> multiLangData = await apiRepo.getData();


          emit(MultiLangSuccessState(multiLangData: multiLangData));
        } catch (e) {
          emit(MultiLangErrorState(e.toString()));
        }
      }
    }

