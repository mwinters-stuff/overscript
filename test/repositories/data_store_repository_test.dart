import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';
import 'package:overscript/global_variable/cubit/global_variable.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/scripts/scripts.dart';
import 'package:overscript/shells/shells.dart';

import '../helpers/helpers.dart';

void main() {
  group('DataStoreRepository', () {
    final mockFileSystem = MockFileSystem();
    final mockFile = MockFile();

    test('load Success', () async {
      final dataStoreRepository = DataStoreRepository(mockDataStoreRepositoryJsonFile());

      // ignore: cascade_invocations
      expect(await dataStoreRepository.load('a-file.json'), isTrue);

      expect(dataStoreRepository.scripts.length, equals(2));
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
      dataStoreRepository.shells.add(realShell1);
      dataStoreRepository.shells.add(realShell2);
      dataStoreRepository.scripts.add(realScript1);
      dataStoreRepository.scripts.add(realScript2);
      dataStoreRepository.gitBranches.add(realGitBranch1);
      dataStoreRepository.gitBranches.add(realGitBranch2);
      dataStoreRepository.branchVariables.add(realBranchVariable1);
      dataStoreRepository.branchVariables.add(realBranchVariable2);
      dataStoreRepository.branchVariableValues.add(realBranchVariableValue1);
      dataStoreRepository.branchVariableValues.add(realBranchVariableValue2);
      dataStoreRepository.globalVariables.add(realGlobalVariable1);
      dataStoreRepository.globalVariables.add(realGlobalVariable2);
      dataStoreRepository.globalEnvironmentVariables.add(realGlobalEnvironmentVariable1);
      dataStoreRepository.globalEnvironmentVariables.add(realGlobalEnvironmentVariable2);

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

    test('add script', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.scripts = dataStoreRepository.addScript(
        const Script(
          uuid: 's-uuid-1',
          shellUuid: 'sh-uuid-1',
          name: 'script-1',
          command: 'command-1',
          workingDirectory: '/working/dir/1',
          runInDocker: false,
          args: [
            'arg-1',
            'arg-2',
            'arg-3',
          ],
          envVars: {
            'env-1': 'env-value-1',
            'env-2': 'env-value-2',
          },
        ),
      );

      expect(dataStoreRepository.scripts.length, equals(1));

      dataStoreRepository.scripts = dataStoreRepository.addScript(
        const Script(
          uuid: 's-uuid-2',
          shellUuid: 'sh-uuid-2',
          name: 'script-2',
          command: 'command-2',
          workingDirectory: '/working/dir/2',
          runInDocker: true,
          args: [
            'arg-1',
            'arg-2',
          ],
          envVars: {
            'env-1': 'env-value-1',
            'env-2': 'env-value-2',
            'env-3': 'env-value-3',
          },
        ),
      );

      expect(dataStoreRepository.scripts.length, equals(2));

      expect(
        dataStoreRepository.scripts[0],
        equals(
          const Script(
            uuid: 's-uuid-1',
            shellUuid: 'sh-uuid-1',
            name: 'script-1',
            command: 'command-1',
            workingDirectory: '/working/dir/1',
            runInDocker: false,
            args: [
              'arg-1',
              'arg-2',
              'arg-3',
            ],
            envVars: {
              'env-1': 'env-value-1',
              'env-2': 'env-value-2',
            },
          ),
        ),
      );

      expect(
        dataStoreRepository.scripts[1],
        equals(
          const Script(
            uuid: 's-uuid-2',
            shellUuid: 'sh-uuid-2',
            name: 'script-2',
            command: 'command-2',
            workingDirectory: '/working/dir/2',
            runInDocker: true,
            args: [
              'arg-1',
              'arg-2',
            ],
            envVars: {
              'env-1': 'env-value-1',
              'env-2': 'env-value-2',
              'env-3': 'env-value-3',
            },
          ),
        ),
      );
    });

    test('delete script', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.scripts.add(
        const Script(
          uuid: 's-uuid-1',
          shellUuid: 'sh-uuid-1',
          name: 'script-1',
          command: 'command-1',
          workingDirectory: '/working/dir/1',
          runInDocker: false,
          args: [
            'arg-1',
            'arg-2',
            'arg-3',
          ],
          envVars: {
            'env-1': 'env-value-1',
            'env-2': 'env-value-2',
          },
        ),
      );

      dataStoreRepository.scripts.add(
        const Script(
          uuid: 's-uuid-2',
          shellUuid: 'sh-uuid-2',
          name: 'script-2',
          command: 'command-2',
          workingDirectory: '/working/dir/2',
          runInDocker: true,
          args: [
            'arg-1',
            'arg-2',
          ],
          envVars: {
            'env-1': 'env-value-1',
            'env-2': 'env-value-2',
            'env-3': 'env-value-3',
          },
        ),
      );
      expect(dataStoreRepository.scripts.length, equals(2));

      dataStoreRepository.scripts = dataStoreRepository.deleteScript(
        const Script(
          uuid: 's-uuid-1',
          shellUuid: 'sh-uuid-1',
          name: 'script-1',
          command: 'command-1',
          workingDirectory: '/working/dir/1',
          runInDocker: false,
          args: [
            'arg-1',
            'arg-2',
            'arg-3',
          ],
          envVars: {
            'env-1': 'env-value-1',
            'env-2': 'env-value-2',
          },
        ),
      );

      expect(dataStoreRepository.scripts.length, equals(1));

      expect(
        dataStoreRepository.scripts[0],
        equals(
          const Script(
            uuid: 's-uuid-2',
            shellUuid: 'sh-uuid-2',
            name: 'script-2',
            command: 'command-2',
            workingDirectory: '/working/dir/2',
            runInDocker: true,
            args: [
              'arg-1',
              'arg-2',
            ],
            envVars: {
              'env-1': 'env-value-1',
              'env-2': 'env-value-2',
              'env-3': 'env-value-3',
            },
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

      var values = dataStoreRepository.variableValues['a-uuid-1']!;

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

      values = dataStoreRepository.variableValues['a-uuid-2']!;

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

    test('getGitBranchRoots', () async {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);
      dataStoreRepository.gitBranches.add(realGitBranch1);
      dataStoreRepository.gitBranches.add(realGitBranch2);

      expect(
        dataStoreRepository.getGitBranchRoots(),
        equals([
          '/home/user/src/project',
          '/home/user/src/banch1',
        ]),
      );
    });

    test('add shell', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.shells = dataStoreRepository.addShell(
        const Shell(
          uuid: 'sh-uuid-1',
          command: '/usr/bin/bash',
          args: [
            '-c',
          ],
        ),
      );

      expect(dataStoreRepository.shells.length, equals(1));

      dataStoreRepository.shells = dataStoreRepository.addShell(
        const Shell(
          uuid: 'sh-uuid-2',
          command: '/usr/bin/zsh',
          args: [],
        ),
      );

      expect(dataStoreRepository.shells.length, equals(2));

      expect(
        dataStoreRepository.shells[0],
        equals(
          const Shell(
            uuid: 'sh-uuid-1',
            command: '/usr/bin/bash',
            args: [
              '-c',
            ],
          ),
        ),
      );

      expect(
        dataStoreRepository.shells[1],
        equals(
          const Shell(
            uuid: 'sh-uuid-2',
            command: '/usr/bin/zsh',
            args: [],
          ),
        ),
      );
    });

    test('delete shell', () {
      final dataStoreRepository = DataStoreRepository(mockFileSystem);

      dataStoreRepository.shells.add(
        const Shell(
          uuid: 'sh-uuid-1',
          command: '/usr/bin/bash',
          args: [
            '-c',
          ],
        ),
      );

      dataStoreRepository.shells.add(
        const Shell(
          uuid: 'sh-uuid-2',
          command: '/usr/bin/zsh',
          args: [],
        ),
      );
      expect(dataStoreRepository.shells.length, equals(2));

      dataStoreRepository.shells = dataStoreRepository.deleteShell(
        const Shell(
          uuid: 'sh-uuid-1',
          command: '/usr/bin/bash',
          args: [
            '-c',
          ],
        ),
      );

      expect(dataStoreRepository.shells.length, equals(1));

      expect(
        dataStoreRepository.shells[0],
        equals(
          const Shell(
            uuid: 'sh-uuid-2',
            command: '/usr/bin/zsh',
            args: [],
          ),
        ),
      );
    });
  });
}
