import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/gitbranch/cubit/gitbranch.dart';

void main() {
  group('GitBranch', () {
    test('Create', () {
      const value = GitBranch(
          uuid: 'uuid', name: 'name', directory: 'directory', origin: 'origin');

      expect(value.uuid, equals('uuid'));
      expect(value.name, equals('name'));
      expect(value.directory, equals('directory'));
      expect(value.origin, equals('origin'));

      expect(value.props, equals(['uuid', 'name', 'directory', 'origin']));
    });

    test('Create Empty', () {
      const value = GitBranch.empty();

      expect(value.uuid, equals(''));
      expect(value.name, equals(''));
      expect(value.directory, equals(''));
      expect(value.origin, equals(''));
      expect(value.props, equals(['', '', '', '']));
    });

    test('to Json', () {
      const value = GitBranch(
          uuid: 'uuid', name: 'name', directory: 'directory', origin: 'origin');

      expect(
          value.toJson(),
          equals({
            'uuid': 'uuid',
            'name': 'name',
            'directory': 'directory',
            'origin': 'origin'
          }));
    });

    test('to String', () {
      const value = GitBranch(
          uuid: 'uuid', name: 'name', directory: 'directory', origin: 'origin');

      expect(
          value.toString(),
          equals(
              '{uuid: uuid, name: name, directory: directory, origin: origin}'));
    });

    test('From Json', () {
      final value = GitBranch.fromJson(const {
        'uuid': 'uuid',
        'name': 'name',
        'directory': 'directory',
        'origin': 'origin'
      });

      expect(
          value,
          equals(const GitBranch(
              uuid: 'uuid',
              name: 'name',
              directory: 'directory',
              origin: 'origin')));
    });
  });
}
