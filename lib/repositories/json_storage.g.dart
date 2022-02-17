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
          allowedKeys: const [
            'scripts',
            'branchVariables',
            'branches',
            'branchVariableValues'
          ],
          requiredKeys: const [
            'scripts',
            'branchVariables',
            'branches',
            'branchVariableValues'
          ],
        );
        final val = JsonStorage(
          scripts: $checkedConvert('scripts', (v) => v as List<dynamic>),
          branchVariables: $checkedConvert(
              'branchVariables',
              (v) => (v as List<dynamic>)
                  .map((e) => BranchVariable.fromJson(e as Map))
                  .toList()),
          branches: $checkedConvert(
              'branches',
              (v) => (v as List<dynamic>)
                  .map((e) => GitBranch.fromJson(e as Map))
                  .toList()),
          branchVariableValues: $checkedConvert(
              'branchVariableValues',
              (v) => (v as List<dynamic>)
                  .map((e) => BranchVariableValue.fromJson(e as Map))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$JsonStorageToJson(JsonStorage instance) =>
    <String, dynamic>{
      'scripts': instance.scripts,
      'branchVariables': instance.branchVariables,
      'branches': instance.branches,
      'branchVariableValues': instance.branchVariableValues,
    };