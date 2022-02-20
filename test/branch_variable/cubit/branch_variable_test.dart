import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/branch_variable/branch_variable.dart';

void main() {
  group('Variable', () {
    test('Create', () {
      const value = BranchVariable(uuid: 'uuid', name: 'name', defaultValue: 'default');

      expect(value.uuid, equals('uuid'));
      expect(value.name, equals('name'));
      expect(value.defaultValue, equals('default'));

      expect(value.props, equals(['uuid', 'name', 'default']));
    });

    test('Create Empty', () {
      const value = BranchVariable.empty();

      expect(value.uuid, equals(''));
      expect(value.name, equals(''));
      expect(value.defaultValue, equals(''));
      expect(value.props, equals(['', '', '']));
    });

    test('to Json', () {
      const value = BranchVariable(
        uuid: 'uuid',
        name: 'name',
        defaultValue: 'default',
      );

      expect(
        value.toJson(),
        equals({
          'uuid': 'uuid',
          'name': 'name',
          'defaultValue': 'default',
        }),
      );
    });

    test('to String', () {
      const value = BranchVariable(
        uuid: 'uuid',
        name: 'name',
        defaultValue: 'default',
      );

      expect(
        value.toString(),
        equals(
          '{\n'
          '  "uuid": "uuid",\n'
          '  "name": "name",\n'
          '  "defaultValue": "default"\n'
          '}',
        ),
      );
    });

    test('From Json', () {
      final value = BranchVariable.fromJson(const {
        'uuid': 'uuid',
        'name': 'name',
        'defaultValue': 'default',
      });

      expect(
        value,
        equals(
          const BranchVariable(
            uuid: 'uuid',
            name: 'name',
            defaultValue: 'default',
          ),
        ),
      );
    });
  });
}
