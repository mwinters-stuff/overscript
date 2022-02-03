// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Variable _$VariableFromJson(Map json) => $checkedCreate(
      'Variable',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['uuid', 'name', 'defaultValue'],
          requiredKeys: const ['uuid', 'name', 'defaultValue'],
        );
        final val = Variable(
          uuid: $checkedConvert('uuid', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          defaultValue: $checkedConvert('defaultValue', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$VariableToJson(Variable instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'defaultValue': instance.defaultValue,
    };
