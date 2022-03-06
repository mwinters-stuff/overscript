import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/repositories/variables_handler.dart';

import '../helpers/helpers.dart';

void main() {
  group('VariablesHandler', () {
    test('suggestVariables', () async {
      final dataStoreRepository = MockDataStoreRepository();
      when(() => dataStoreRepository.suggestiveVariables).thenReturn({
        'g-variable-1': 'value1',
        'g-variable-2': 'value2',
        'variable1': 'start value 1',
        'variable2': 'start value 2',
      });

      final variablesHandler = VariablesHandler(dataStoreRepository);

      expect(variablesHandler.suggestVariables(''), equals(''));

      expect(
        variablesHandler.suggestVariables('Some value1 is 10'),
        equals('Some {g-variable-1} is 10'),
      );
      expect(
        variablesHandler.suggestVariables('Some start value 1 is not'),
        equals('Some {variable1} is not'),
      );
      expect(
        variablesHandler.suggestVariables('Some start value 2 is not'),
        equals('Some {variable2} is not'),
      );

      expect(
        variablesHandler.suggestVariables('The value1 is not start value 2 and not value2'),
        equals('The {g-variable-1} is not {variable2} and not {g-variable-2}'),
      );

      expect(
        variablesHandler.suggestVariables('The Home Path for ${Platform.environment['USERNAME'] ?? ''} is ${Platform.environment['HOME'] ?? ''}'),
        equals('The Home Path for {USERNAME} is {HOME}'),
      );
    });

    test('suggestBaseVariables', () async {
      final dataStoreRepository = MockDataStoreRepository();

      final variablesHandler = VariablesHandler(dataStoreRepository);

      expect(variablesHandler.suggestBaseVariables(''), equals(''));

      expect(
        variablesHandler.suggestBaseVariables(
          'Variable HOME = ${Platform.environment['HOME'] ?? ''}',
        ),
        equals('Variable HOME = {HOME}'),
      );

      expect(
        variablesHandler.suggestBaseVariables(
          'Variable USERNAME = ${Platform.environment['USERNAME'] ?? ''}',
        ),
        equals('Variable USERNAME = {USERNAME}'),
      );
    });

    test('suggestGitOrHomePath', () async {
      final dataStoreRepository = MockDataStoreRepository();
      when(dataStoreRepository.getGitBranchRoots).thenReturn([
        '/home/user/src/project',
        '/home/user/src/banch1',
      ]);
      final variablesHandler = VariablesHandler(dataStoreRepository);

      expect(variablesHandler.suggestGitOrHomePath(''), equals(''));

      expect(
        variablesHandler.suggestGitOrHomePath(
          '${Platform.environment['HOME']!}/some/path',
        ),
        equals('{HOME}/some/path'),
      );
      expect(
        variablesHandler.suggestGitOrHomePath(
          '/home/user/src/project/and/some/path/therein',
        ),
        equals('{GITROOT}/and/some/path/therein'),
      );
      expect(
        variablesHandler.suggestGitOrHomePath(
          '/home/user/src/banch1',
        ),
        equals('{GITROOT}'),
      );
    });

    test('replaceVariables', () async {
      final dataStoreRepository = MockDataStoreRepository();

      when(() => dataStoreRepository.variableValues).thenReturn(<String, Map<String, String>>{
        'b-uuid-1': {
          'variable1': 'Value 1',
          'variable2': 'Value 2',
          'variable3': 'Value 3',
          'variable4': 'Value 1',
        }
      });

      final variablesHandler = VariablesHandler(dataStoreRepository);

      expect(
        variablesHandler.replaceVariables('', 'b-uuid-1'),
        equals(''),
      );

      expect(
        variablesHandler.replaceVariables('The {variable1} is Value 1', 'b-uuid-1'),
        equals('The Value 1 is Value 1'),
      );
      expect(
        variablesHandler.replaceVariables('The {variable2} is not {variable1}', 'b-uuid-1'),
        equals('The Value 2 is not Value 1'),
      );
      expect(
        variablesHandler.replaceVariables('The {variable4} is {variable1}', 'b-uuid-1'),
        equals('The Value 1 is Value 1'),
      );
      expect(
        variablesHandler.replaceVariables('The {{variable3}} is {variable1}', 'b-uuid-1'),
        equals('The {Value 3} is Value 1'),
      );

      expect(
        variablesHandler.replaceVariables('The home for {USERNAME} is {HOME}', 'b-uuid-1'),
        equals('The home for ${Platform.environment['USERNAME'] ?? ''} is ${Platform.environment['HOME'] ?? ''}'),
      );
    });
  });
}
