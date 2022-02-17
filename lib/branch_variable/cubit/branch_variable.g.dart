// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_variable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchVariable _$BranchVariableFromJson(Map json) => $checkedCreate(
      'BranchVariable',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['uuid', 'name', 'defaultValue'],
          requiredKeys: const ['uuid', 'name', 'defaultValue'],
        );
        final val = BranchVariable(
          uuid: $checkedConvert('uuid', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          defaultValue: $checkedConvert('defaultValue', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$BranchVariableToJson(BranchVariable instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'defaultValue': instance.defaultValue,
    };
