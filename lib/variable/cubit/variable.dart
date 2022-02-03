// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'variable.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class Variable extends Equatable {
  const Variable({
    required this.uuid,
    required this.name,
    required this.defaultValue,
  });

  const Variable.empty()
      : uuid = '',
        name = '',
        defaultValue = '';

  factory Variable.fromJson(Map json) => _$VariableFromJson(json);

  @JsonKey(required: true)
  final String uuid;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String defaultValue;

  Map<String, dynamic> toJson() => _$VariableToJson(this);
  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [uuid, name, defaultValue];
}
