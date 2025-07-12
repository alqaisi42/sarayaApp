

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/subscriptionCountBloc/subscription_count_event.dart';
import 'package:newsapp/bloc/subscriptionCountBloc/subscription_count_state.dart';

import '../../Model/subscription_counts_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/post_api_repo.dart';

class SubscriptionCountBloc extends Bloc<SubscriptionCountEvent, SubscriptionCountState> {
  final PostapiRepo<SubscriptionCountsModel> postapiRepo;

  SubscriptionCountBloc()
      : postapiRepo = PostapiRepo<SubscriptionCountsModel>(
    fromJson: (json) => SubscriptionCountsModel.fromJson(json),
    isToken: true,
  ),
        super(SubscriptionCountInitial()) {
    on<PostSubscriptionCount>(_onPostSubscriptionCount);
  }

  Future<void> _onPostSubscriptionCount(
      PostSubscriptionCount event, Emitter<SubscriptionCountState> emit) async {
    emit(SubscriptionCountLoading());

    try {
      final response = await postapiRepo.postData('$subscriptionCountsUrl/${event.countType}');
      emit(SubscriptionCountLoaded(subscriptionCountData: response));
    } catch (e) {
      emit(SubscriptionCountError(errorMessage: e.toString()));
    }
  }
}