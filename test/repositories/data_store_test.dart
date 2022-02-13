import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/variable/variable.dart';

import '../helpers/helpers.dart';

void main() {
  group('DataStoreRepository', () {
    final mockFileSystem = MockFileSystem();
    final mockFile = MockFile();

    test('load Success', () async {
      final dataStoreRepository = DataStoreRepository(mockDataStoreRepositoryJsonFile());

      // ignore: cascade_invocations
      expect(await dataStoreRepository.load('a-file.json'), isTrue);

      expect(dataStoreRepository.branches.length, equals(1));
      expect(dataStoreRepository.scripts.length, equals(0));
      expect(dataStoreRepository.variables.length, equals(1));
      expect(dataStoreRepository.branchVariableValues.length, equals(1));
    });

    test('load file doesnt exist', () async {
      when(() => mockFileSystem.isFileSync('a-file.json')).thenReturn(false);
      when(() => mockFileSystem.file('a-file.json')).thenReturn(mockFile);

      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      // ignore: cascade_invocations
      expect(await dataStoreRepository.load('a-file.json'), isFalse);

      expect(dataStoreRepository.branches.length, equals(0));
      expect(dataStoreRepository.scripts.length, equals(0));
      expect(dataStoreRepository.variables.length, equals(0));
      expect(dataStoreRepository.branchVariableValues.length, equals(0));
    });

    test('save Success', () async {
      when(() => mockFileSystem.file('a-file.json')).thenReturn(mockFile);
      when(() => mockFile.writeAsString(any())).thenAnswer((_) => Future.value(mockFile));

      final dataStoreRepository = DataStoreRepository(mockFileSystem);
      dataStoreRepository.branches.add(const GitBranch(uuid: 'uuid', name: 'name', directory: 'directory', origin: 'origin'));
      dataStoreRepository.variables.add(const Variable(uuid: 'uuid', name: 'name', defaultValue: 'defaultValue'));
      dataStoreRepository.branchVariableValues.add(const BranchVariableValue(uuid: 'uuid', branchUuid: 'branchUuid', variableUuid: 'variableUuid', value: 'value'));

      // ignore: cascade_invocations
      expect(await dataStoreRepository.save('a-file.json'), isTrue);

      final captured = verify(() => mockFile.writeAsString(captureAny<String>())).captured;
      expect(captured.length, equals(1));
      expect(
        captured.last as String,
        equals(
          '{\n'
          '  "scripts": [],\n'
          '  "variables": [\n'
          '    {\n'
          '      "uuid": "uuid",\n'
          '      "name": "name",\n'
          '      "defaultValue": "defaultValue"\n'
          '    }\n'
          '  ],\n'
          '  "branches": [\n'
          '    {\n'
          '      "uuid": "uuid",\n'
          '      "name": "name",\n'
          '      "directory": "directory",\n'
          '      "origin": "origin"\n'
          '    }\n'
          '  ],\n'
          '  "branchVariableValues": [\n'
          '    {\n'
          '      "uuid": "uuid",\n'
          '      "branchUuid": "branchUuid",\n'
          '      "variableUuid": "variableUuid",\n'
          '      "value": "value"\n'
          '    }\n'
          '  ]\n'
          '}',
        ),
      );
    });

    test('add variable, adds branch variable values', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.branches.add(const GitBranch(uuid: 'b-uuid-1', name: 'branch 1', directory: 'directory1', origin: 'origin'));
      dataStoreRepository.branches.add(const GitBranch(uuid: 'b-uuid-2', name: 'branch 2', directory: 'directory2', origin: 'origin'));

      dataStoreRepository.addVariable(const Variable(uuid: 'v-uuid-1', name: 'variable', defaultValue: 'defaultValue'));

      expect(dataStoreRepository.branchVariableValues.length, equals(2));

      expect(
        dataStoreRepository.branchVariableValues[0].branchUuid,
        equals('b-uuid-1'),
      );
      expect(
        dataStoreRepository.branchVariableValues[0].variableUuid,
        equals('v-uuid-1'),
      );
      expect(
        dataStoreRepository.branchVariableValues[0].value,
        equals('defaultValue'),
      );

      expect(
        dataStoreRepository.branchVariableValues[1].branchUuid,
        equals('b-uuid-2'),
      );
      expect(
        dataStoreRepository.branchVariableValues[1].variableUuid,
        equals('v-uuid-1'),
      );
      expect(
        dataStoreRepository.branchVariableValues[1].value,
        equals('defaultValue'),
      );
    });

    test('delete variable, removes branch variables values', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.branches.add(const GitBranch(uuid: 'b-uuid-1', name: 'branch 1', directory: 'directory1', origin: 'origin'));
      dataStoreRepository.branches.add(const GitBranch(uuid: 'b-uuid-2', name: 'branch 2', directory: 'directory2', origin: 'origin'));

      dataStoreRepository.addVariable(const Variable(uuid: 'v-uuid-1', name: 'variable', defaultValue: 'defaultValue'));
      expect(dataStoreRepository.branchVariableValues.length, equals(2));

      dataStoreRepository.deleteVariable(const Variable(uuid: 'v-uuid-1', name: 'variable', defaultValue: 'defaultValue'));

      expect(dataStoreRepository.branchVariableValues.length, equals(0));
    });

    test('add branch, adds branch variable values', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.variables.add(const Variable(uuid: 'v-uuid-1', name: 'variable 1', defaultValue: 'defaultValue1'));
      dataStoreRepository.variables.add(const Variable(uuid: 'v-uuid-2', name: 'variable 2', defaultValue: 'defaultValue2'));

      dataStoreRepository.addBranch(const GitBranch(uuid: 'b-uuid-1', name: 'branch 1', directory: 'directory1', origin: 'origin'));

      expect(dataStoreRepository.branchVariableValues.length, equals(2));

      expect(
        dataStoreRepository.branchVariableValues[0].branchUuid,
        equals('b-uuid-1'),
      );
      expect(
        dataStoreRepository.branchVariableValues[0].variableUuid,
        equals('v-uuid-1'),
      );
      expect(
        dataStoreRepository.branchVariableValues[0].value,
        equals('defaultValue1'),
      );

      expect(
        dataStoreRepository.branchVariableValues[1].branchUuid,
        equals('b-uuid-1'),
      );
      expect(
        dataStoreRepository.branchVariableValues[1].variableUuid,
        equals('v-uuid-2'),
      );
      expect(
        dataStoreRepository.branchVariableValues[1].value,
        equals('defaultValue2'),
      );
    });

    test('delete branch, removes branch variables values', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.variables.add(const Variable(uuid: 'v-uuid-1', name: 'variable 1', defaultValue: 'defaultValue1'));
      dataStoreRepository.variables.add(const Variable(uuid: 'v-uuid-2', name: 'variable 2', defaultValue: 'defaultValue2'));

      dataStoreRepository.addBranch(const GitBranch(uuid: 'b-uuid-1', name: 'branch 1', directory: 'directory1', origin: 'origin'));

      expect(dataStoreRepository.branchVariableValues.length, equals(2));

      dataStoreRepository.deleteBranch(const GitBranch(uuid: 'b-uuid-1', name: 'branch 1', directory: 'directory1', origin: 'origin'));

      expect(dataStoreRepository.branchVariableValues.length, equals(0));
    });
  });
}
