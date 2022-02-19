import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/global_variable/global_variable.dart';

void main() {
  group('GlobalVariable', () {
    test('Create', () {
      const value = GlobalVariable(uuid: 'uuid', name: 'name', value: 'value');

      expect(value.uuid, equals('uuid'));
      expect(value.name, equals('name'));
      expect(value.value, equals('value'));

      expect(value.props, equals(['uuid', 'name', 'value']));
    });

    test('Create Empty', () {
      const value = GlobalVariable.empty();

      expect(value.uuid, equals(''));
      expect(value.name, equals(''));
      expect(value.value, equals(''));
      expect(value.props, equals(['', '', '']));
    });

    test('copyWithNewValue', () {
      const value = GlobalVariable(uuid: 'uuid', name: 'name', value: 'value');

      expect(
        value.copyWithNewValue(newValue: 'new-value'),
        equals(const GlobalVariable(uuid: 'uuid', name: 'name', value: 'new-value')),
      );
    });

    test('to Json', () {
      const value = GlobalVariable(
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
      const value = GlobalVariable(
        uuid: 'uuid',
        name: 'name',
        value: 'value',
      );

      expect(
        value.toString(),
        equals(
          '{uuid: uuid, name: name, value: value}',
        ),
      );
    });

    test('From Json', () {
      final value = GlobalVariable.fromJson(const {
        'uuid': 'uuid',
        'name': 'name',
        'value': 'value',
      });

      expect(
        value,
        equals(
          const GlobalVariable(
            uuid: 'uuid',
            name: 'name',
            value: 'value',
          ),
        ),
      );
    });
  });
}
