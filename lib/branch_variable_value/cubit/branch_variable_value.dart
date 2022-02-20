// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'branch_variable_value.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class BranchVariableValue extends Equatable {
  const BranchVariableValue({required this.uuid, required this.branchUuid, required this.variableUuid, required this.value});

  const BranchVariableValue.empty()
      : uuid = '',
        branchUuid = '',
        variableUuid = '',
        value = '';

  factory BranchVariableValue.fromJson(Map json) => _$BranchVariableValueFromJson(json);

  BranchVariableValue copyWithNewValue({required String newValue}) {
    return BranchVariableValue(uuid: uuid, branchUuid: branchUuid, variableUuid: variableUuid, value: newValue);
  }

  @JsonKey(required: true)
  final String uuid;
  @JsonKey(required: true)
  final String branchUuid;
  @JsonKey(required: true)
  final String variableUuid;
  @JsonKey(required: true)
  final String value;

  Map<String, dynamic> toJson() => _$BranchVariableValueToJson(this);
  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(this);

  @override
  List<Object?> get props => [uuid, branchUuid, variableUuid, value];
}
