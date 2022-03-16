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
            'shells',
            'scripts',
            'branchVariables',
            'gitBranches',
            'branchVariableValues',
            'globalVariables',
            'globalEnvironmentVariables'
          ],
          requiredKeys: const [
            'shells',
            'scripts',
            'branchVariables',
            'gitBranches',
            'branchVariableValues',
            'globalVariables',
            'globalEnvironmentVariables'
          ],
        );
        final val = JsonStorage(
          shells: $checkedConvert(
              'shells',
              (v) => (v as List<dynamic>)
                  .map((e) => Shell.fromJson(e as Map))
                  .toList()),
          scripts: $checkedConvert(
              'scripts',
              (v) => (v as List<dynamic>)
                  .map((e) => Script.fromJson(e as Map))
                  .toList()),
          branchVariables: $checkedConvert(
              'branchVariables',
              (v) => (v as List<dynamic>)
                  .map((e) => BranchVariable.fromJson(e as Map))
                  .toList()),
          gitBranches: $checkedConvert(
              'gitBranches',
              (v) => (v as List<dynamic>)
                  .map((e) => GitBranch.fromJson(e as Map))
                  .toList()),
          branchVariableValues: $checkedConvert(
              'branchVariableValues',
              (v) => (v as List<dynamic>)
                  .map((e) => BranchVariableValue.fromJson(e as Map))
                  .toList()),
          globalVariables: $checkedConvert(
              'globalVariables',
              (v) => (v as List<dynamic>)
                  .map((e) => GlobalVariable.fromJson(e as Map))
                  .toList()),
          globalEnvironmentVariables: $checkedConvert(
              'globalEnvironmentVariables',
              (v) => (v as List<dynamic>)
                  .map((e) => GlobalEnvironmentVariable.fromJson(e as Map))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$JsonStorageToJson(JsonStorage instance) =>
    <String, dynamic>{
      'shells': instance.shells,
      'scripts': instance.scripts,
      'branchVariables': instance.branchVariables,
      'gitBranches': instance.gitBranches,
      'branchVariableValues': instance.branchVariableValues,
      'globalVariables': instance.globalVariables,
      'globalEnvironmentVariables': instance.globalEnvironmentVariables,
    };
