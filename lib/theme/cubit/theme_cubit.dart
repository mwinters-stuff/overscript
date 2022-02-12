import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  // final lightScheme = ColorScheme.fromSeed(seedColor: Colors.green);
  // final darkScheme = ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark);

  final lightTheme = ThemeData(colorSchemeSeed: Colors.deepOrange[600], useMaterial3: true);
  final darkTheme = ThemeData(colorSchemeSeed: Colors.deepOrange[600], brightness: Brightness.dark, useMaterial3: true);

  @override
  ThemeState? fromJson(Map<String, dynamic> json) => ThemeState(
        status: (json['isDark'] as bool) ? ThemeStatus.dark : ThemeStatus.light,
      );

  @override
  Map<String, dynamic>? toJson(ThemeState state) => {'isDark': state.status.isDark};

  void setDark() {
    emit(state.setDark());
  }

  void setLight() {
    emit(state.setLight());
  }

  void toggle() {
    emit(state.toggle());
  }

  ThemeData getTheme() {
    return state.status.isDark ? darkTheme : lightTheme;
  }
}
