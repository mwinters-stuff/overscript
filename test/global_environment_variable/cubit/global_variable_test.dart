import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';

void main() {
  group('GlobalEnvironmentVariable', () {
    test('Create', () {
      const value = GlobalEnvironmentVariable(uuid: 'uuid', name: 'name', value: 'value');

      expect(value.uuid, equals('uuid'));
      expect(value.name, equals('name'));
      expect(value.value, equals('value'));

      expect(value.props, equals(['uuid', 'name', 'value']));
    });

    test('Create Empty', () {
      const value = GlobalEnvironmentVariable.empty();

      expect(value.uuid, equals(''));
      expect(value.name, equals(''));
      expect(value.value, equals(''));
      expect(value.props, equals(['', '', '']));
    });

    test('copyWithNewValue', () {
      const value = GlobalEnvironmentVariable(uuid: 'uuid', name: 'name', value: 'value');

      expect(
        value.copyWithNewValue(newValue: 'new-value'),
        equals(const GlobalEnvironmentVariable(uuid: 'uuid', name: 'name', value: 'new-value')),
      );
    });

    test('to Json', () {
      const value = GlobalEnvironmentVariable(
        uuid: 'uuid',
        name: 'name',
        value: 'value',
      );

      expect(
        value.toJson(),
        equals({
          'uuid': 'uuid',
          'name': 'name',
          'value': 'value',
        }),
      );
    });

    test('to String', () {
      const value = GlobalEnvironmentVariable(
        uuid: 'uuid',
        name: 'name',
        value: 'value',
      );

      expect(
        value.toString(),
        equals(
          '{\n'
          '  "uuid": "uuid",\n'
          '  "name": "name",\n'
          '  "value": "value"\n'
          '}',
        ),
      );
    });

    test('From Json', () {
      final value = GlobalEnvironmentVariable.fromJson(const {
        'uuid': 'uuid',
        'name': 'name',
        'value': 'value',
      });

      expect(
        value,
        equals(
          const GlobalEnvironmentVariable(
            uuid: 'uuid',
            name: 'name',
            value: 'value',
          ),
        ),
      );
    });
  });
}
