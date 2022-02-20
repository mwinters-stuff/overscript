// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'git_branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GitBranch _$GitBranchFromJson(Map json) => $checkedCreate(
      'GitBranch',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['uuid', 'name', 'directory', 'origin'],
          requiredKeys: const ['uuid', 'name', 'directory', 'origin'],
        );
        final val = GitBranch(
          uuid: $checkedConvert('uuid', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          directory: $checkedConvert('directory', (v) => v as String),
          origin: $checkedConvert('origin', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$GitBranchToJson(GitBranch instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'directory': instance.directory,
      'origin': instance.origin,
    };
