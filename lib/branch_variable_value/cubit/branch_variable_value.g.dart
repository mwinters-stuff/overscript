// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_variable_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchVariableValue _$BranchVariableValueFromJson(Map json) => $checkedCreate(
      'BranchVariableValue',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['uuid', 'branchUuid', 'variableUuid', 'value'],
          requiredKeys: const ['uuid', 'branchUuid', 'variableUuid', 'value'],
        );
        final val = BranchVariableValue(
          uuid: $checkedConvert('uuid', (v) => v as String),
          branchUuid: $checkedConvert('branchUuid', (v) => v as String),
          variableUuid: $checkedConvert('variableUuid', (v) => v as String),
          value: $checkedConvert('value', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$BranchVariableValueToJson(
        BranchVariableValue instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'branchUuid': instance.branchUuid,
      'variableUuid': instance.variableUuid,
      'value': instance.value,
    };
