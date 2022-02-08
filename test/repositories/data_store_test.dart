import 'dart:io';

import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/repositories/json_storage.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/variable/variable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:process/process.dart';

class MockFileSystem extends Mock implements FileSystem {}

class MockFile extends Mock implements File {}

void main() {
  group('DataStoreRepository', () {
    test('load Success', () {
      final mockFileSystem = MockFileSystem();
      final mockFile = MockFile();

      when(mockFile.readAsStringSync).thenReturn(
        '{"scripts": [], "variables": [{"uuid": "v-uuid-1", "name": "variable1", "defaultValue": "default1"}], "branches": [{"uuid": "a-uuid-1", "name": "master", "directory": "/home/user/src/project", "origin": "git:someplace/bob"}], "branchVariableValues": [{"uuid": "bvv-uuid-1", "branchUuid": "a-uuid-1", "variableUuid": "v-uuid-1", "value": "start value 1"}]}',
      );
      when(() => mockFileSystem.isFileSync('a-file.json')).thenReturn(true);
      when(() => mockFileSystem.file('a-file.json')).thenReturn(mockFile);

      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      // ignore: cascade_invocations
      dataStoreRepository.load('a-file.json');

      expect(dataStoreRepository.branches.length, equals(1));
      expect(dataStoreRepository.scripts.length, equals(0));
      expect(dataStoreRepository.variables.length, equals(1));
      expect(dataStoreRepository.branchVariableValues.length, equals(1));
    });

    test('load file doesnt exist', () {
      final mockFileSystem = MockFileSystem();
      final mockFile = MockFile();

      when(() => mockFileSystem.isFileSync('a-file.json')).thenReturn(false);
      when(() => mockFileSystem.file('a-file.json')).thenReturn(mockFile);

      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      // ignore: cascade_invocations
      dataStoreRepository.load('a-file.json');

      expect(dataStoreRepository.branches.length, equals(0));
      expect(dataStoreRepository.scripts.length, equals(0));
      expect(dataStoreRepository.variables.length, equals(0));
      expect(dataStoreRepository.branchVariableValues.length, equals(0));
    });

    test('save Success', () {
      final mockFileSystem = MockFileSystem();
      final mockFile = MockFile();

      when(() => mockFileSystem.file('a-file.json')).thenReturn(mockFile);

      final dataStoreRepository = DataStoreRepository(mockFileSystem);
      dataStoreRepository.branches.add(const GitBranch(uuid: 'uuid', name: 'name', directory: 'directory', origin: 'origin'));
      dataStoreRepository.variables.add(const Variable(uuid: 'uuid', name: 'name', defaultValue: 'defaultValue'));
      dataStoreRepository.branchVariableValues.add(const BranchVariableValue(uuid: 'uuid', branchUuid: 'branchUuid', variableUuid: 'variableUuid', value: 'value'));

      // ignore: cascade_invocations
      dataStoreRepository.save('a-file.json');

      final captured = verify(() => mockFile.writeAsStringSync(captureAny<String>())).captured;
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
  });
}
