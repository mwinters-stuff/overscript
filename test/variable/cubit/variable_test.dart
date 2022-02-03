import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/variable/cubit/variable.dart';

void main() {
  group('Variable', () {
    test('Create', () {
      const value = Variable(uuid: 'uuid', name: 'name', defaultValue: 'default');

      expect(value.uuid, equals('uuid'));
      expect(value.name, equals('name'));
      expect(value.defaultValue, equals('default'));

      expect(value.props, equals(['uuid', 'name', 'default']));
    });

    test('Create Empty', () {
      const value = Variable.empty();

      expect(value.uuid, equals(''));
      expect(value.name, equals(''));
      expect(value.defaultValue, equals(''));
      expect(value.props, equals(['', '', '']));
    });

    test('to Json', () {
      const value = Variable(
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
      const value = Variable(
        uuid: 'uuid',
        name: 'name',
        defaultValue: 'default',
      );

      expect(
        value.toString(),
        equals(
          '{uuid: uuid, name: name, defaultValue: default}',
        ),
      );
    });

    test('From Json', () {
      final value = Variable.fromJson(const {
        'uuid': 'uuid',
        'name': 'name',
        'defaultValue': 'default',
      });

      expect(
        value,
        equals(
          const Variable(
            uuid: 'uuid',
            name: 'name',
            defaultValue: 'default',
          ),
        ),
      );
    });
  });
}
