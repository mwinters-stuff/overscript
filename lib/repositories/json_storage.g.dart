// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonStorage _$JsonStorageFromJson(Map json) => $checkedCreate(
      'JsonStorage',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['scripts', 'variables', 'branches'],
          requiredKeys: const ['scripts', 'variables', 'branches'],
        );
        final val = JsonStorage(
          scripts: $checkedConvert('scripts', (v) => v as List<dynamic>),
          variables: $checkedConvert('variables', (v) => v as List<dynamic>),
          branches: $checkedConvert(
              'branches',
              (v) => (v as List<dynamic>)
                  .map((e) => GitBranch.fromJson(e as Map))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$JsonStorageToJson(JsonStorage instance) =>
    <String, dynamic>{
      'scripts': instance.scripts,
      'variables': instance.variables,
      'branches': instance.branches,
    };
