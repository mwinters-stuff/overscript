import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/scripts/scripts.dart';

void main() {
  group('Script', () {
    test('Create', () {
      const value = Script(
        uuid: 'uuid',
        shellUuid: 'uuid-shell',
        name: 'a script',
        command: 'command',
        runInDocker: false,
        workingDirectory: '/home/a/directory',
        args: [
          'arg1',
          'arg2',
        ],
        envVars: {
          'ev1': 'eval1',
          'ev2': 'eval2',
        },
      );

      expect(value.uuid, equals('uuid'));
      expect(value.shellUuid, equals('uuid-shell'));
      expect(value.name, equals('a script'));
      expect(value.command, equals('command'));
      expect(value.runInDocker, isFalse);
      expect(value.workingDirectory, equals('/home/a/directory'));

      expect(
        value.args,
        equals(
          ['arg1', 'arg2'],
        ),
      );
      expect(
        value.envVars,
        equals({
          'ev1': 'eval1',
          'ev2': 'eval2',
        }),
      );
    });

    test('Create Empty', () {
      const value = Script.empty();

      expect(value.uuid, equals(''));
      expect(value.shellUuid, equals(''));
      expect(value.name, equals(''));
      expect(value.command, equals(''));
      expect(value.runInDocker, isFalse);
      expect(value.workingDirectory, equals(''));
      expect(value.args, equals([]));
      expect(value.envVars, equals({}));
    });

    test('to Json', () {
      const value = Script(
        uuid: 'uuid',
        shellUuid: 'uuid-shell',
        name: 'a script',
        command: 'command',
        runInDocker: false,
        workingDirectory: '/home/a/directory',
        args: [
          'arg1',
          'arg2',
        ],
        envVars: {
          'ev1': 'eval1',
          'ev2': 'eval2',
        },
      );
      expect(
        value.toJson(),
        equals({
          'uuid': 'uuid',
          'shellUuid': 'uuid-shell',
          'name': 'a script',
          'command': 'command',
          'args': ['arg1', 'arg2'],
          'workingDirectory': '/home/a/directory',
          'runInDocker': false,
          'envVars': {'ev1': 'eval1', 'ev2': 'eval2'}
        }),
      );
    });

    test('to String', () {
      const value = Script(
        uuid: 'uuid',
        shellUuid: 'uuid-shell',
        name: 'a script',
        command: 'command',
        runInDocker: false,
        workingDirectory: '/home/a/directory',
        args: [
          'arg1',
          'arg2',
        ],
        envVars: {
          'ev1': 'eval1',
          'ev2': 'eval2',
        },
      );

      expect(
        value.toString(),
        equals('{uuid: uuid, shellUuid: uuid-shell, name: a script, command: command, args: [arg1, arg2], workingDirectory: /home/a/directory, runInDocker: false, envVars: {ev1: eval1, ev2: eval2}}'),
      );
    });

    test('From Json', () {
      final value = Script.fromJson(const {
        'uuid': 'uuid',
        'shellUuid': 'uuid-shell',
        'name': 'a script',
        'command': 'command',
        'args': ['arg1', 'arg2'],
        'workingDirectory': '/home/a/directory',
        'runInDocker': false,
        'envVars': {'ev1': 'eval1', 'ev2': 'eval2'}
      });

      expect(
        value,
        equals(
          const Script(
            uuid: 'uuid',
            shellUuid: 'uuid-shell',
            name: 'a script',
            command: 'command',
            runInDocker: false,
            workingDirectory: '/home/a/directory',
            args: [
              'arg1',
              'arg2',
            ],
            envVars: {
              'ev1': 'eval1',
              'ev2': 'eval2',
            },
          ),
        ),
      );
    });
  });
}
