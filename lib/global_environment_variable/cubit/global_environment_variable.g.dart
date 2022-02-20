// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_environment_variable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalEnvironmentVariable _$GlobalEnvironmentVariableFromJson(Map json) =>
    $checkedCreate(
      'GlobalEnvironmentVariable',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['uuid', 'name', 'value'],
          requiredKeys: const ['uuid', 'name', 'value'],
        );
        final val = GlobalEnvironmentVariable(
          uuid: $checkedConvert('uuid', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          value: $checkedConvert('value', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$GlobalEnvironmentVariableToJson(
        GlobalEnvironmentVariable instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'value': instance.value,
    };
