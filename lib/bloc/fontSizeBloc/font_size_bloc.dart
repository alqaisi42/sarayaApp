


import 'package:flutter_bloc/flutter_bloc.dart';


import '../../config/helper/helper_functions.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';

import 'font_size_event.dart';
import 'font_size_state.dart';

class FontSizeBloc extends Bloc<FontSizeEvent, FontSizeState> {
  final HiveStorage _hiveStorage = HiveStorage();
  static FontSizeBloc? _instance;

  // Getter to access or create the instance
  static FontSizeBloc get instance {
    _instance ??= FontSizeBloc._internal();
    return _instance!;
  }


  FontSizeBloc._internal() : super(FontSizeInitial()) {
    on<LoadFontSize>(_onLoadFontSize);
    on<ChangeFontSize>(_onChangeFontSize);
  }


  factory FontSizeBloc() {
    return instance;
  }


  static Future<void> initFontSize() async {
    try {
      final savedFontSize = await instance._hiveStorage.getFontSize();


      final fontSize = savedFontSize != null
          ? FontSize.fromString(savedFontSize)
          : FontSize.medium;


      _instance!.add(ChangeFontSize(fontSize));
    } catch (e) {


      _instance!.add(ChangeFontSize(FontSize.medium));
    }
  }

  Future<void> _onLoadFontSize(
      LoadFontSize event,
      Emitter<FontSizeState> emit,
      ) async {
    emit(FontSizeLoading());
    try {
      final savedFontSize = await _hiveStorage.getFontSize();

      final fontSize = savedFontSize != null
          ? FontSize.fromString(savedFontSize)
          : FontSize.medium;

      emit(FontSizeLoaded(fontSize));
    } catch (e) {
      emit(FontSizeError('Failed to load font size: $e'));
    }
  }

  Future<void> _onChangeFontSize(
      ChangeFontSize event,
      Emitter<FontSizeState> emit,
      ) async {
    emit(FontSizeLoading());
    try {
      await _hiveStorage.storeFontSize(event.fontSize.name);

      emit(FontSizeLoaded(event.fontSize));
    } catch (e) {
      emit(FontSizeError('Failed to save font size: $e'));
    }
  }
}