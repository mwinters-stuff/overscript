import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/git_branch/git_branch.dart';
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
    required this.branches,
    required this.branchVariableValues,
    required this.globalVariables,
  });

  factory JsonStorage.fromJson(Map<String, dynamic> json) => _$JsonStorageFromJson(json);

  const JsonStorage.empty()
      : scripts = const [],
        branchVariables = const [],
        branches = const [],
        branchVariableValues = const [],
        globalVariables = const [];

  @JsonKey(required: true)
  final List<dynamic> scripts;
  @JsonKey(required: true)
  final List<BranchVariable> branchVariables;
  @JsonKey(required: true)
  final List<GitBranch> branches;
  @JsonKey(required: true)
  final List<BranchVariableValue> branchVariableValues;
  @JsonKey(required: true)
  final List<GlobalVariable> globalVariables;

  Map<String, dynamic> toJson() => _$JsonStorageToJson(this);

  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [
        scripts,
        branchVariables,
        branches,
        branchVariableValues,
        globalVariables,
      ];
}
