// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Script _$ScriptFromJson(Map json) => $checkedCreate(
      'Script',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'uuid',
            'shellUuid',
            'name',
            'command',
            'args',
            'workingDirectory',
            'runInDocker',
            'envVars'
          ],
          requiredKeys: const [
            'uuid',
            'shellUuid',
            'name',
            'command',
            'args',
            'workingDirectory',
            'runInDocker',
            'envVars'
          ],
        );
        final val = Script(
          uuid: $checkedConvert('uuid', (v) => v as String),
          shellUuid: $checkedConvert('shellUuid', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          command: $checkedConvert('command', (v) => v as String),
          args: $checkedConvert('args',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          workingDirectory:
              $checkedConvert('workingDirectory', (v) => v as String),
          runInDocker: $checkedConvert('runInDocker', (v) => v as bool),
          envVars: $checkedConvert(
              'envVars', (v) => Map<String, String>.from(v as Map)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ScriptToJson(Script instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'shellUuid': instance.shellUuid,
      'name': instance.name,
      'command': instance.command,
      'args': instance.args,
      'workingDirectory': instance.workingDirectory,
      'runInDocker': instance.runInDocker,
      'envVars': instance.envVars,
    };
