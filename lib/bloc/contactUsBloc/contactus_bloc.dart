

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Model/contact_us_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/post_api_repo.dart';
import 'conactus_state.dart';
import 'contactus_event.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {


  ContactUsBloc() : super(ContactUsInitial()) {
    on<ContactUsPost>(_onContactUsPost);
  }

  Future<void> _onContactUsPost(ContactUsPost event, Emitter<ContactUsState> emit) async {
    try {
      emit(ContactUsLoading());
      final repo = PostapiRepo<ContactUsModel>(
        fromJson: (json) => ContactUsModel.fromJson(json),
        isToken: false,
      );
      final response = await repo.postData(
        contactUsUrl,
        email: event.userEmail,
        userMessage: event.userMessage,
      );
      emit(ContactUsSuccess(contactUsData: response));
    } catch (e) {
      emit(ContactUsError(error: e.toString()));
    }
  }

}