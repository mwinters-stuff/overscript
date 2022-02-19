// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'global_variable.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class GlobalVariable extends Equatable {
  const GlobalVariable({
    required this.uuid,
    required this.name,
    required this.value,
  });

  const GlobalVariable.empty()
      : uuid = '',
        name = '',
        value = '';

  factory GlobalVariable.fromJson(Map json) => _$GlobalVariableFromJson(json);

  @JsonKey(required: true)
  final String uuid;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String value;

  Map<String, dynamic> toJson() => _$GlobalVariableToJson(this);
  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [uuid, name, value];

  GlobalVariable copyWithNewValue({required String newValue}) {
    return GlobalVariable(uuid: uuid, name: name, value: newValue);
  }
}
