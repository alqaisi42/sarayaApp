import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../config/constants.dart';


import '../../config/hiveLocalStorage/hive_storage.dart';
import 'language_switcher_event.dart';
import 'language_switcher_state.dart';




class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final HiveStorage _storage;
  static LanguageBloc? _instance;

  static LanguageBloc get instance => _instance ??= LanguageBloc._internal();

  LanguageBloc._internal() : _storage = HiveStorage(), super(LanguageState.initial()) {
    on<ChangeLanguage>(_onChangeLanguage);

  }


  static Future<void> initLanguage() async {
    final savedLanguage = await instance._storage.getLanguage();
    final hiveDefaultLanguage = await instance._storage.getDefaultLanguage();
    await HiveStorage().storeDefaultLanguage(defaultLanguage);

    if (hiveDefaultLanguage != null && hiveDefaultLanguage != defaultLanguage) {
      await instance._storage.storeLanguage(defaultLanguage);
      instance.add(ChangeLanguage(languageCode: defaultLanguage));
    } else if (savedLanguage != null) {
      instance.add(ChangeLanguage(languageCode: savedLanguage));
    }
  }


  Future<void> _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit,) async {
    await _storage.storeLanguage(event.languageCode);
    emit(state.copyWith(locale: Locale(event.languageCode)));
  }
}



