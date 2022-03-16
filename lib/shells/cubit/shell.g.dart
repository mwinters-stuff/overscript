// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shell _$ShellFromJson(Map json) => $checkedCreate(
      'Shell',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['uuid', 'command', 'args'],
          requiredKeys: const ['uuid', 'command', 'args'],
        );
        final val = Shell(
          uuid: $checkedConvert('uuid', (v) => v as String),
          command: $checkedConvert('command', (v) => v as String),
          args: $checkedConvert('args',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$ShellToJson(Shell instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'command': instance.command,
      'args': instance.args,
    };
