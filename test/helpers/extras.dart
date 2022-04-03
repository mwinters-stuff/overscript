import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';
import 'package:overscript/global_variable/global_variable.dart';
import 'package:overscript/scripts/scripts.dart';
import 'package:overscript/shells/shells.dart';

GitBranch realGitBranch1 = const GitBranch(
  uuid: 'a-uuid-1',
  name: 'master',
  directory: '/home/user/src/project',
  origin: 'git:someplace/bob',
);

GitBranch realGitBranch2 = const GitBranch(
  uuid: 'a-uuid-2',
  name: 'branch-one',
  directory: '/home/user/src/banch1',
  origin: 'git:someplace/bob',
);

BranchVariable realBranchVariable1 = const BranchVariable(
  uuid: 'v-uuid-1',
  name: 'variable1',
  defaultValue: 'default1',
);

BranchVariable realBranchVariable2 = const BranchVariable(
  uuid: 'v-uuid-2',
  name: 'variable2',
  defaultValue: 'default2',
);

BranchVariableValue realBranchVariableValue1 = const BranchVariableValue(
  uuid: 'bvv-uuid-1',
  branchUuid: 'a-uuid-1',
  variableUuid: 'v-uuid-1',
  value: 'start value 1',
);

BranchVariableValue realBranchVariableValue2 = const BranchVariableValue(
  uuid: 'bvv-uuid-2',
  branchUuid: 'a-uuid-2',
  variableUuid: 'v-uuid-1',
  value: 'start value 2',
);

GlobalVariable realGlobalVariable1 = const GlobalVariable(
  uuid: 'gv-uuid-1',
  name: 'g-variable-1',
  value: 'value1',
);
GlobalVariable realGlobalVariable2 = const GlobalVariable(
  uuid: 'gv-uuid-2',
  name: 'g-variable-2',
  value: 'value2',
);

GlobalEnvironmentVariable realGlobalEnvironmentVariable1 = const GlobalEnvironmentVariable(
  uuid: 'ge-uuid-1',
  name: 'g-env-1',
  value: 'value1',
);

GlobalEnvironmentVariable realGlobalEnvironmentVariable2 = const GlobalEnvironmentVariable(
  uuid: 'ge-uuid-2',
  name: 'g-env-2',
  value: 'value2',
);

Shell realShell1 = const Shell(
  uuid: 'sh-uuid-1',
  command: '/usr/bin/bash',
  args: [
    '-c',
  ],
);

Shell realShell2 = const Shell(
  uuid: 'sh-uuid-2',
  command: '/usr/bin/zsh',
  args: [],
);

Script realScript1 = const Script(
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
);

Script realScript1a = const Script(
  uuid: 's-uuid-1',
  shellUuid: 'sh-uuid-3',
  name: 'script-2',
  command: 'command-3',
  workingDirectory: '/working/dir/4',
  runInDocker: false,
  args: [],
  envVars: {},
);

Script realScript2 = const Script(
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
);

const fileContents = '''
{
  "shells": [
    {
      "uuid": "sh-uuid-1",
      "command": "/usr/bin/bash",
      "args": [
        "-c"
      ]
    },
    {
      "uuid": "sh-uuid-2",
      "command": "/usr/bin/zsh",
      "args": []
    }
  ],
  "scripts": [
    {
      "uuid": "s-uuid-1",
      "shellUuid": "sh-uuid-1",
      "name": "script-1",
      "command": "command-1",
      "args": [
        "arg-1",
        "arg-2",
        "arg-3"
      ],
      "workingDirectory": "/working/dir/1",
      "runInDocker": false,
      "envVars": {
        "env-1": "env-value-1",
        "env-2": "env-value-2"
      }
    },
    {
      "uuid": "s-uuid-2",
      "shellUuid": "sh-uuid-2",
      "name": "script-2",
      "command": "command-2",
      "args": [
        "arg-1",
        "arg-2"
      ],
      "workingDirectory": "/working/dir/2",
      "runInDocker": true,
      "envVars": {
        "env-1": "env-value-1",
        "env-2": "env-value-2",
        "env-3": "env-value-3"
      }
    }
  ],
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
