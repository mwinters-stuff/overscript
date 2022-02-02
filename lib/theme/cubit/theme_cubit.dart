import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  @override
  ThemeState? fromJson(Map<String, dynamic> json) => ThemeState(status: (json['isDark'] as bool) ? ThemeStatus.dark : ThemeStatus.light);

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
    //  ThemeData(
    //     appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
    //     colorScheme: ColorScheme.fromSwatch(
    //       accentColor: const Color(0xFF13B9FF),
    //     ),
    //   ),
    return state.status.isDark ? ThemeData.dark() : ThemeData.light();
  }
}
