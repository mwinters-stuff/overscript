import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';

void main() {
  group('BranchVariableValue', () {
    test('Create', () {
      final value = BranchVariableValue(
        uuid: 'uuid',
        branchUuid: 'branch-uuid',
        variableUuid: 'variable-uuid',
        value: 'value',
      );

      expect(value.uuid, equals('uuid'));
      expect(value.branchUuid, equals('branch-uuid'));
      expect(value.variableUuid, equals('variable-uuid'));
      expect(value.value, equals('value'));

      expect(
        value.props,
        equals([
          'uuid',
          'branch-uuid',
          'variable-uuid',
          'value',
        ]),
      );
    });

    test('Create Empty', () {
      final value = BranchVariableValue.empty();

      expect(value.uuid, equals(''));
      expect(value.branchUuid, equals(''));
      expect(value.variableUuid, equals(''));
      expect(value.value, equals(''));
    });

    test('to Json', () {
      final value = BranchVariableValue(uuid: 'uuid', branchUuid: 'branch-uuid', variableUuid: 'variable-uuid', value: 'value');

      expect(
        value.toJson(),
        equals({'uuid': 'uuid', 'branchUuid': 'branch-uuid', 'variableUuid': 'variable-uuid', 'value': 'value'}),
      );
    });

    test('to String', () {
      final value = BranchVariableValue(uuid: 'uuid', branchUuid: 'branch-uuid', variableUuid: 'variable-uuid', value: 'value');

      expect(
        value.toString(),
        equals(
          '{uuid: uuid, branchUuid: branch-uuid, variableUuid: variable-uuid, value: value}',
        ),
      );
    });

    test('From Json', () {
      final value = BranchVariableValue.fromJson(const {'uuid': 'uuid', 'branchUuid': 'branch-uuid', 'variableUuid': 'variable-uuid', 'value': 'value'});

      expect(
        value,
        equals(
          BranchVariableValue(uuid: 'uuid', branchUuid: 'branch-uuid', variableUuid: 'variable-uuid', value: 'value'),
        ),
      );
    });
  });
}
