import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';
import 'package:overscript/global_variable/global_variable.dart';

part 'json_storage.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class JsonStorage extends Equatable {
  const JsonStorage({
    required this.scripts,
    required this.branchVariables,
    required this.gitBranches,
    required this.branchVariableValues,
    required this.globalVariables,
    required this.globalEnvironmentVariables,
  });

  factory JsonStorage.fromJson(Map<String, dynamic> json) => _$JsonStorageFromJson(json);

  const JsonStorage.empty()
      : scripts = const [],
        branchVariables = const [],
        gitBranches = const [],
        branchVariableValues = const [],
        globalVariables = const [],
        globalEnvironmentVariables = const [];

  @JsonKey(required: true)
  final List<dynamic> scripts;
  @JsonKey(required: true)
  final List<BranchVariable> branchVariables;
  @JsonKey(required: true)
  final List<GitBranch> gitBranches;
  @JsonKey(required: true)
  final List<BranchVariableValue> branchVariableValues;
  @JsonKey(required: true)
  final List<GlobalVariable> globalVariables;
  @JsonKey(required: true)
  final List<GlobalEnvironmentVariable> globalEnvironmentVariables;

  Map<String, dynamic> toJson() => _$JsonStorageToJson(this);

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(this);

  @override
  List<Object?> get props => [
        scripts,
        branchVariables,
        gitBranches,
        branchVariableValues,
        globalVariables,
        globalEnvironmentVariables,
      ];
}
