import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsapp/bloc/themeBloc/theme_switcher_event.dart';



// class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
//   ThemeBloc() : super(ThemeMode.system) {
//     on<ThemeChanged>((event, emit) {
//       _saveTheme(event.themeMode);
//       emit(event.themeMode);
//     });
//     _loadTheme();
//   }
//
//   void _saveTheme(ThemeMode theme) {
//     final box = Hive.box('themebox');
//     box.put('themeMode', theme.index);
//   }
//
//   void _loadTheme() {
//     final box = Hive.box('themebox');
//     final themeIndex =
//         box.get('themeMode', defaultValue: ThemeMode.system.index);
//     emit(ThemeMode.values[themeIndex]);
//   }
// }

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.system) {
    on<ThemeChanged>((event, emit) {
      _saveTheme(event.themeMode);
      emit(event.themeMode);
    });
    on<InitializeTheme>(_loadTheme);
    add(InitializeTheme());
  }

  void _saveTheme(ThemeMode theme) {
    final box = Hive.box('themebox');
    box.put('themeMode', theme.index);
  }

  void _loadTheme(InitializeTheme event, Emitter<ThemeMode> emit) {
    final box = Hive.box('themebox');
    final themeIndex = box.get('themeMode', defaultValue: ThemeMode.system.index);
    emit(ThemeMode.values[themeIndex]);
  }
}
