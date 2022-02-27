import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/repositories/variables_handler.dart';

import '../helpers/helpers.dart';

void main() {
  group('VariablesHandler', () {
    test('suggestVariables', () async {
      final dataStoreRepository = MockDataStoreRepository();
      when(() => dataStoreRepository.globalVariables).thenReturn([mockGlobalVariable1, mockGlobalVariable2]);
      when(() => dataStoreRepository.branchVariables).thenReturn([mockBranchVariable1, mockBranchVariable2]);
      when(() => dataStoreRepository.branchVariableValues).thenReturn([mockBranchVariableValue1, mockBranchVariableValue2]);
      when(() => dataStoreRepository.getBranchVariable('v-uuid-1')).thenReturn(mockBranchVariable1);
      when(() => dataStoreRepository.getBranchVariable('v-uuid-2')).thenReturn(mockBranchVariable2);

      final variablesHandler = VariablesHandler(dataStoreRepository);

      expect(variablesHandler.suggestVariables(''), equals(''));

      expect(variablesHandler.suggestVariables('Some value1 is 10'), equals('Some {g-variable-1} is 10'));
      expect(variablesHandler.suggestVariables('Some start value 1 is not'), equals('Some {variable1} is not'));
      expect(variablesHandler.suggestVariables('Some start value 2 is not'), equals('Some {variable1} is not'));

      expect(variablesHandler.suggestVariables('The value1 is not start value 2 and not value2'), equals('The {g-variable-1} is not {variable1} and not {g-variable-2}'));
    });

    test('replaceVariables', () async {
      final dataStoreRepository = MockDataStoreRepository();

      when(() => dataStoreRepository.getVariableValues('b-uuid-1')).thenReturn({
        'variable1': 'Value 1',
        'variable2': 'Value 2',
        'variable3': 'Value 3',
        'variable4': 'Value 1',
      });

      final variablesHandler = VariablesHandler(dataStoreRepository);

      expect(variablesHandler.replaceVariables('', 'b-uuid-1'), equals(''));

      expect(variablesHandler.replaceVariables('The {variable1} is Value 1', 'b-uuid-1'), equals('The Value 1 is Value 1'));
      expect(variablesHandler.replaceVariables('The {variable2} is not {variable1}', 'b-uuid-1'), equals('The Value 2 is not Value 1'));
      expect(variablesHandler.replaceVariables('The {variable4} is {variable1}', 'b-uuid-1'), equals('The Value 1 is Value 1'));
      expect(variablesHandler.replaceVariables('The {{variable3}} is {variable1}', 'b-uuid-1'), equals('The {Value 3} is Value 1'));
    });
  });
}
