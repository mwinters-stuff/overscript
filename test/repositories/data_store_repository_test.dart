import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';
import 'package:overscript/global_variable/cubit/global_variable.dart';
import 'package:overscript/repositories/repositories.dart';

import '../helpers/helpers.dart';

void main() {
  group('DataStoreRepository', () {
    final mockFileSystem = MockFileSystem();
    final mockFile = MockFile();

    test('load Success', () async {
      final dataStoreRepository = DataStoreRepository(mockDataStoreRepositoryJsonFile());

      // ignore: cascade_invocations
      expect(await dataStoreRepository.load('a-file.json'), isTrue);

      expect(dataStoreRepository.scripts.length, equals(0));
      expect(dataStoreRepository.gitBranches.length, equals(2));
      expect(dataStoreRepository.branchVariables.length, equals(2));
      expect(dataStoreRepository.branchVariableValues.length, equals(2));
      expect(dataStoreRepository.globalVariables.length, equals(2));
      expect(dataStoreRepository.globalEnvironmentVariables.length, equals(2));
    });

    test('load file does not exist', () async {
      when(() => mockFileSystem.isFileSync('a-file.json')).thenReturn(false);
      when(() => mockFileSystem.file('a-file.json')).thenReturn(mockFile);

      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      // ignore: cascade_invocations
      expect(await dataStoreRepository.load('a-file.json'), isFalse);

      expect(dataStoreRepository.gitBranches.length, equals(0));
      expect(dataStoreRepository.scripts.length, equals(0));
      expect(dataStoreRepository.branchVariables.length, equals(0));
      expect(dataStoreRepository.branchVariableValues.length, equals(0));
      expect(dataStoreRepository.globalVariables.length, equals(0));
      expect(dataStoreRepository.globalEnvironmentVariables.length, equals(0));
    });

    test('save Success', () async {
      when(() => mockFileSystem.file('a-file.json')).thenReturn(mockFile);
      when(() => mockFile.writeAsString(any())).thenAnswer((_) => Future.value(mockFile));

      final dataStoreRepository = DataStoreRepository(mockFileSystem);
      dataStoreRepository.gitBranches.add(mockGitBranch1);
      dataStoreRepository.gitBranches.add(mockGitBranch2);
      dataStoreRepository.branchVariables.add(mockBranchVariable1);
      dataStoreRepository.branchVariables.add(mockBranchVariable2);
      dataStoreRepository.branchVariableValues.add(mockBranchVariableValue1);
      dataStoreRepository.branchVariableValues.add(mockBranchVariableValue2);
      dataStoreRepository.globalVariables.add(mockGlobalVariable1);
      dataStoreRepository.globalVariables.add(mockGlobalVariable2);
      dataStoreRepository.globalEnvironmentVariables.add(mockGlobalEnvironmentVariable1);
      dataStoreRepository.globalEnvironmentVariables.add(mockGlobalEnvironmentVariable2);

      // ignore: cascade_invocations
      expect(await dataStoreRepository.save('a-file.json'), isTrue);

      final captured = verify(() => mockFile.writeAsString(captureAny<String>())).captured;
      expect(captured.length, equals(1));
      expect(
        captured.last as String,
        equals(fileContents),
      );
    });

    test('add variable, adds branch variable values', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.gitBranches.add(const GitBranch(uuid: 'b-uuid-1', name: 'branch 1', directory: 'directory1', origin: 'origin'));
      dataStoreRepository.gitBranches.add(const GitBranch(uuid: 'b-uuid-2', name: 'branch 2', directory: 'directory2', origin: 'origin'));

      dataStoreRepository.addBranchVariable(const BranchVariable(uuid: 'v-uuid-1', name: 'variable', defaultValue: 'defaultValue'));

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

      dataStoreRepository.gitBranches.add(const GitBranch(uuid: 'b-uuid-1', name: 'branch 1', directory: 'directory1', origin: 'origin'));
      dataStoreRepository.gitBranches.add(const GitBranch(uuid: 'b-uuid-2', name: 'branch 2', directory: 'directory2', origin: 'origin'));

      dataStoreRepository.addBranchVariable(const BranchVariable(uuid: 'v-uuid-1', name: 'variable', defaultValue: 'defaultValue'));
      expect(dataStoreRepository.branchVariableValues.length, equals(2));

      dataStoreRepository.deleteBranchVariable(const BranchVariable(uuid: 'v-uuid-1', name: 'variable', defaultValue: 'defaultValue'));

      expect(dataStoreRepository.branchVariableValues.length, equals(0));
    });

    test('add branch, adds branch variable values', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.branchVariables.add(const BranchVariable(uuid: 'v-uuid-1', name: 'variable 1', defaultValue: 'defaultValue1'));
      dataStoreRepository.branchVariables.add(const BranchVariable(uuid: 'v-uuid-2', name: 'variable 2', defaultValue: 'defaultValue2'));

      dataStoreRepository.addGitBranch(const GitBranch(uuid: 'b-uuid-1', name: 'branch 1', directory: 'directory1', origin: 'origin'));

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

      dataStoreRepository.branchVariables.add(const BranchVariable(uuid: 'v-uuid-1', name: 'variable 1', defaultValue: 'defaultValue1'));
      dataStoreRepository.branchVariables.add(const BranchVariable(uuid: 'v-uuid-2', name: 'variable 2', defaultValue: 'defaultValue2'));

      dataStoreRepository.addGitBranch(const GitBranch(uuid: 'b-uuid-1', name: 'branch 1', directory: 'directory1', origin: 'origin'));

      expect(dataStoreRepository.branchVariableValues.length, equals(2));

      dataStoreRepository.deleteGitBranch(const GitBranch(uuid: 'b-uuid-1', name: 'branch 1', directory: 'directory1', origin: 'origin'));

      expect(dataStoreRepository.branchVariableValues.length, equals(0));
    });

    test('add global variable', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.globalVariables = dataStoreRepository.addGlobalVariable(
        const GlobalVariable(
          uuid: 'a-uuid-1',
          name: 'variable1',
          value: 'value1',
        ),
      );

      expect(dataStoreRepository.globalVariables.length, equals(1));

      dataStoreRepository.globalVariables = dataStoreRepository.addGlobalVariable(
        const GlobalVariable(
          uuid: 'a-uuid-2',
          name: 'variable2',
          value: 'value2',
        ),
      );

      expect(dataStoreRepository.globalVariables.length, equals(2));

      expect(
        dataStoreRepository.globalVariables[0],
        equals(
          const GlobalVariable(
            uuid: 'a-uuid-1',
            name: 'variable1',
            value: 'value1',
          ),
        ),
      );

      expect(
        dataStoreRepository.globalVariables[1],
        equals(
          const GlobalVariable(
            uuid: 'a-uuid-2',
            name: 'variable2',
            value: 'value2',
          ),
        ),
      );
    });

    test('delete global variable', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.globalVariables.add(
        const GlobalVariable(
          uuid: 'a-uuid-1',
          name: 'variable1',
          value: 'value1',
        ),
      );

      dataStoreRepository.globalVariables.add(
        const GlobalVariable(
          uuid: 'a-uuid-2',
          name: 'variable2',
          value: 'value2',
        ),
      );

      expect(dataStoreRepository.globalVariables.length, equals(2));

      dataStoreRepository.globalVariables = dataStoreRepository.deleteGlobalVariable(
        const GlobalVariable(
          uuid: 'a-uuid-1',
          name: 'variable1',
          value: 'value1',
        ),
      );

      expect(dataStoreRepository.globalVariables.length, equals(1));

      expect(
        dataStoreRepository.globalVariables[0],
        equals(
          const GlobalVariable(
            uuid: 'a-uuid-2',
            name: 'variable2',
            value: 'value2',
          ),
        ),
      );
    });

    test('add global environment variable', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.globalEnvironmentVariables = dataStoreRepository.addGlobalEnvironmentVariable(
        const GlobalEnvironmentVariable(
          uuid: 'a-uuid-1',
          name: 'variable1',
          value: 'value1',
        ),
      );

      expect(dataStoreRepository.globalEnvironmentVariables.length, equals(1));

      dataStoreRepository.globalEnvironmentVariables = dataStoreRepository.addGlobalEnvironmentVariable(
        const GlobalEnvironmentVariable(
          uuid: 'a-uuid-2',
          name: 'variable2',
          value: 'value2',
        ),
      );

      expect(dataStoreRepository.globalEnvironmentVariables.length, equals(2));

      expect(
        dataStoreRepository.globalEnvironmentVariables[0],
        equals(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid-1',
            name: 'variable1',
            value: 'value1',
          ),
        ),
      );

      expect(
        dataStoreRepository.globalEnvironmentVariables[1],
        equals(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid-2',
            name: 'variable2',
            value: 'value2',
          ),
        ),
      );
    });

    test('delete global environment variable', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.globalEnvironmentVariables.add(
        const GlobalEnvironmentVariable(
          uuid: 'a-uuid-1',
          name: 'variable1',
          value: 'value1',
        ),
      );

      dataStoreRepository.globalEnvironmentVariables.add(
        const GlobalEnvironmentVariable(
          uuid: 'a-uuid-2',
          name: 'variable2',
          value: 'value2',
        ),
      );

      expect(dataStoreRepository.globalEnvironmentVariables.length, equals(2));

      dataStoreRepository.globalEnvironmentVariables = dataStoreRepository.deleteGlobalEnvironmentVariable(
        const GlobalEnvironmentVariable(
          uuid: 'a-uuid-1',
          name: 'variable1',
          value: 'value1',
        ),
      );

      expect(dataStoreRepository.globalEnvironmentVariables.length, equals(1));

      expect(
        dataStoreRepository.globalEnvironmentVariables[0],
        equals(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid-2',
            name: 'variable2',
            value: 'value2',
          ),
        ),
      );
    });

    test('getBranchVariable', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.branchVariables.add(const BranchVariable(uuid: 'v-uuid-1', name: 'variable 1', defaultValue: 'defaultValue1'));
      dataStoreRepository.branchVariables.add(const BranchVariable(uuid: 'v-uuid-2', name: 'variable 2', defaultValue: 'defaultValue2'));

      expect(
        dataStoreRepository.getBranchVariable('v-uuid-1'),
        equals(
          const BranchVariable(
            uuid: 'v-uuid-1',
            name: 'variable 1',
            defaultValue: 'defaultValue1',
          ),
        ),
      );
      expect(
        dataStoreRepository.getBranchVariable('v-uuid-2'),
        equals(
          const BranchVariable(
            uuid: 'v-uuid-2',
            name: 'variable 2',
            defaultValue: 'defaultValue2',
          ),
        ),
      );
    });

    test('getVariableValues', () async {
      final dataStoreRepository = DataStoreRepository(mockDataStoreRepositoryJsonFile());

      expect(await dataStoreRepository.load('a-file.json'), isTrue);

      var values = dataStoreRepository.getVariableValues('a-uuid-1');

      expect(values.length, equals(4));
      expect(
        values,
        equals(
          {
            'g-variable-1': 'value1',
            'g-variable-2': 'value2',
            'variable1': 'start value 1',
            'variable2': 'default2',
          },
        ),
      );

      values = dataStoreRepository.getVariableValues('a-uuid-2');

      expect(values.length, equals(4));
      expect(
        values,
        equals(
          {
            'g-variable-1': 'value1',
            'g-variable-2': 'value2',
            'variable1': 'start value 2',
            'variable2': 'default2',
          },
        ),
      );
    });
  });
}
