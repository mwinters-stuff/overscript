// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'global_environment_variable.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class GlobalEnvironmentVariable extends Equatable {
  const GlobalEnvironmentVariable({
    required this.uuid,
    required this.name,
    required this.value,
  });

  const GlobalEnvironmentVariable.empty()
      : uuid = '',
        name = '',
        value = '';

  factory GlobalEnvironmentVariable.fromJson(Map json) => _$GlobalEnvironmentVariableFromJson(json);

  @JsonKey(required: true)
  final String uuid;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String value;

  Map<String, dynamic> toJson() => _$GlobalEnvironmentVariableToJson(this);
  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(this);

  @override
  List<Object?> get props => [uuid, name, value];

  GlobalEnvironmentVariable copyWithNewValue({required String newValue}) {
    return GlobalEnvironmentVariable(uuid: uuid, name: name, value: newValue);
  }
}
