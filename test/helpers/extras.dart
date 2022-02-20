import 'package:file/file.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';
import 'package:overscript/global_variable/global_variable.dart';

import 'mocks.dart';

GitBranch mockGitBranch1 = const GitBranch(
  uuid: 'a-uuid-1',
  name: 'master',
  directory: '/home/user/src/project',
  origin: 'git:someplace/bob',
);

GitBranch mockGitBranch2 = const GitBranch(
  uuid: 'a-uuid-2',
  name: 'branch-one',
  directory: '/home/user/src/banch1',
  origin: 'git:someplace/bob',
);

BranchVariable mockVariable1 = const BranchVariable(
  uuid: 'v-uuid-1',
  name: 'variable1',
  defaultValue: 'default1',
);

BranchVariable mockVariable2 = const BranchVariable(
  uuid: 'v-uuid-2',
  name: 'variable2',
  defaultValue: 'default2',
);

BranchVariableValue mockBranchVariableValue1 = const BranchVariableValue(
  uuid: 'bvv-uuid-1',
  branchUuid: 'a-uuid-1',
  variableUuid: 'v-uuid-1',
  value: 'start value 1',
);

BranchVariableValue mockBranchVariableValue2 = const BranchVariableValue(
  uuid: 'bvv-uuid-2',
  branchUuid: 'a-uuid-2',
  variableUuid: 'v-uuid-1',
  value: 'start value 2',
);

GlobalVariable mockGlobalVariable1 = const GlobalVariable(
  uuid: 'gv-uuid-1',
  name: 'g-variable-1',
  value: 'value1',
);
GlobalVariable mockGlobalVariable2 = const GlobalVariable(
  uuid: 'gv-uuid-2',
  name: 'g-variable-2',
  value: 'value2',
);

GlobalEnvironmentVariable mockGlobalEnvironmentVariable1 = const GlobalEnvironmentVariable(
  uuid: 'ge-uuid-1',
  name: 'g-env-1',
  value: 'value1',
);

GlobalEnvironmentVariable mockGlobalEnvironmentVariable2 = const GlobalEnvironmentVariable(
  uuid: 'ge-uuid-2',
  name: 'g-env-2',
  value: 'value2',
);

const fileContents = '''
{
  "scripts": [],
  "branchVariables": [
    {
      "uuid": "v-uuid-1",
      "name": "variable1",
      "defaultValue": "default1"
    },
    {
      "uuid": "v-uuid-2",
      "name": "variable2",
      "defaultValue": "default2"
    }
  ],
  "gitBranches": [
    {
      "uuid": "a-uuid-1",
      "name": "master",
      "directory": "/home/user/src/project",
      "origin": "git:someplace/bob"
    },
    {
      "uuid": "a-uuid-2",
      "name": "branch-one",
      "directory": "/home/user/src/banch1",
      "origin": "git:someplace/bob"
    }
  ],
  "branchVariableValues": [
    {
      "uuid": "bvv-uuid-1",
      "branchUuid": "a-uuid-1",
      "variableUuid": "v-uuid-1",
      "value": "start value 1"
    },
    {
      "uuid": "bvv-uuid-2",
      "branchUuid": "a-uuid-2",
      "variableUuid": "v-uuid-1",
      "value": "start value 2"
    }
  ],
  "globalVariables": [
    {
      "uuid": "gv-uuid-1",
      "name": "g-variable-1",
      "value": "value1"
    },
    {
      "uuid": "gv-uuid-2",
      "name": "g-variable-2",
      "value": "value2"
    }
  ],
  "globalEnvironmentVariables": [
    {
      "uuid": "ge-uuid-1",
      "name": "g-env-1",
      "value": "value1"
    },
    {
      "uuid": "ge-uuid-2",
      "name": "g-env-2",
      "value": "value2"
    }
  ]
}''';

FileSystem mockDataStoreRepositoryJsonFile() {
  final mockFileSystem = MockFileSystem();

  final mockFile = MockFile();

  when(mockFile.readAsStringSync).thenReturn(fileContents);
  when(mockFile.readAsString).thenAnswer((_) => Future.value(fileContents));

  when(() => mockFileSystem.isFileSync('a-file.json')).thenReturn(true);
  when(() => mockFileSystem.file('a-file.json')).thenReturn(mockFile);
  return mockFileSystem;
}
