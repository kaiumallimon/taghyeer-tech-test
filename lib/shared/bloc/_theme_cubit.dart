import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_test/core/storage/_local_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(LocalStorage.fetchThemeMode());

  Future<void> setTheme(ThemeMode mode) async {
    await LocalStorage.saveThemeMode(mode);
    emit(mode);
  }
}
