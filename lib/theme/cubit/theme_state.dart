part of 'theme_cubit.dart';

enum ThemeStatus { light, dark }

extension ThemeStatusX on ThemeStatus {
  bool get isLight => this == ThemeStatus.light;
  bool get isDark => this == ThemeStatus.dark;
}

class ThemeState extends Equatable {
  const ThemeState({this.status = ThemeStatus.light});

  final ThemeStatus status;

  ThemeState copyWith({ThemeStatus? status}) {
    return ThemeState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];

  ThemeState setLight() {
    return copyWith(status: ThemeStatus.light);
  }

  ThemeState setDark() {
    return copyWith(status: ThemeStatus.dark);
  }

  ThemeState toggle() {
    return status.isDark ? setLight() : setDark();
  }
}
