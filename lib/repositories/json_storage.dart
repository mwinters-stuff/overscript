import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:overscript/gitbranch/cubit/gitbranch.dart';

part 'json_storage.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class JsonStorage extends Equatable {
  const JsonStorage({required this.scripts, required this.variables, required this.branches});

  factory JsonStorage.fromJson(Map<String, dynamic> json) => _$JsonStorageFromJson(json);

  const JsonStorage.empty()
      : scripts = const [],
        variables = const [],
        branches = const [];

  @JsonKey(required: true)
  final List<dynamic> scripts;
  @JsonKey(required: true)
  final List<dynamic> variables;
  @JsonKey(required: true)
  final List<GitBranch> branches;

  Map<String, dynamic> toJson() => _$JsonStorageToJson(this);

  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [scripts, variables, branches];
}
