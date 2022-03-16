import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/shells/shells.dart';

void main() {
  group('Shell', () {
    test('Create', () {
      const value = Shell(
        uuid: 'uuid',
        command: 'command',
        args: [
          'arg1',
          'arg2',
        ],
      );

      expect(value.uuid, equals('uuid'));
      expect(value.command, equals('command'));

      expect(
        value.args,
        equals(
          ['arg1', 'arg2'],
        ),
      );
    });

    test('Create Empty', () {
      const value = Shell.empty();

      expect(value.uuid, equals(''));
      expect(value.command, equals(''));
      expect(value.args, equals([]));
    });

    test('copyWithNewArgs', () {
      const value = Shell(
        uuid: 'uuid',
        command: 'command',
        args: [
          'arg1',
          'arg2',
        ],
      );
      expect(
        value.copyWithNewArgs(newArgs: 'new-arg1 new-arg2 new-arg3'),
        equals(
          const Shell(
            uuid: 'uuid',
            command: 'command',
            args: ['new-arg1', 'new-arg2', 'new-arg3'],
          ),
        ),
      );
    });

    test('to Json', () {
      const value = Shell(
        uuid: 'uuid',
        command: 'command',
        args: [
          'arg1',
          'arg2',
        ],
      );
      expect(
        value.toJson(),
        equals({
          'uuid': 'uuid',
          'command': 'command',
          'args': ['arg1', 'arg2'],
        }),
      );
    });

    test('to String', () {
      const value = Shell(
        uuid: 'uuid',
        command: 'command',
        args: [
          'arg1',
          'arg2',
        ],
      );

      expect(
        value.toString(),
        equals('{uuid: uuid, command: command, args: [arg1, arg2]}'),
      );
    });

    test('From Json', () {
      final value = Shell.fromJson(const {
        'uuid': 'uuid',
        'command': 'command',
        'args': ['arg1', 'arg2'],
      });

      expect(
        value,
        equals(
          const Shell(
            uuid: 'uuid',
            command: 'command',
            args: [
              'arg1',
              'arg2',
            ],
          ),
        ),
      );
    });
  });
}
