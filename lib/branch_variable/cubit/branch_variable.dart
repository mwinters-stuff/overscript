// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'branch_variable.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class BranchVariable extends Equatable {
  const BranchVariable({
    required this.uuid,
    required this.name,
    required this.defaultValue,
  });

  const BranchVariable.empty()
      : uuid = '',
        name = '',
        defaultValue = '';

  factory BranchVariable.fromJson(Map json) => _$BranchVariableFromJson(json);

  @JsonKey(required: true)
  final String uuid;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String defaultValue;

  Map<String, dynamic> toJson() => _$BranchVariableToJson(this);
  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [uuid, name, defaultValue];
}
