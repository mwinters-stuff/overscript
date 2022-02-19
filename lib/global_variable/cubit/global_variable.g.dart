// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_variable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalVariable _$GlobalVariableFromJson(Map json) => $checkedCreate(
      'GlobalVariable',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['uuid', 'name', 'value'],
          requiredKeys: const ['uuid', 'name', 'value'],
        );
        final val = GlobalVariable(
          uuid: $checkedConvert('uuid', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          value: $checkedConvert('value', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$GlobalVariableToJson(GlobalVariable instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'value': instance.value,
    };
