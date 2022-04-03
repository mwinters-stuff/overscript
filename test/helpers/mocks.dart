import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:file/file.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';
import 'package:overscript/global_variable/global_variable.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/scripts/scripts.dart';
import 'package:overscript/shells/shells.dart';
import 'package:process/process.dart';

import 'helpers.dart';

class MockDataStoreRepository extends Mock implements DataStoreRepository {}

class MockGitBranchesCubit extends MockCubit<GitBranchesState> implements GitBranchesCubit {}

class MockGitBranchesState extends Mock implements GitBranchesState {}

class MockGitBranch extends Mock implements GitBranch {}

class MockGitCalls extends Mock implements GitCalls {}

class MockBranchVariableValuesCubit extends MockCubit<BranchVariableValuesState> implements BranchVariableValuesCubit {}

class MockBranchVariableValuesState extends Mock implements BranchVariableValuesState {}

class MockBranchVariableValueState extends Mock implements BranchVariableValuesState {}

class MockBranchVariableValue extends Mock implements BranchVariableValue {}

class MockBranchVariable extends Mock implements BranchVariable {}

class MockBranchVariablesCubit extends MockCubit<BranchVariablesState> implements BranchVariablesCubit {}

class MockBranchVariablesState extends Mock implements BranchVariablesState {}

class MockGlobalVariable extends Mock implements GlobalVariable {}

class MockGlobalVariablesCubit extends MockCubit<GlobalVariablesState> implements GlobalVariablesCubit {}

class MockGlobalVariablesState extends Mock implements GlobalVariablesState {}

class MockFileSystem extends Mock implements FileSystem {}

class MockFile extends Mock implements File {}

class MockProcessManager extends Mock implements ProcessManager {}

class MockProcessResult extends Mock implements ProcessResult {}

class MockGlobalEnvironmentVariable extends Mock implements GlobalEnvironmentVariable {}

class MockGlobalEnvironmentVariablesCubit extends MockCubit<GlobalEnvironmentVariablesState> implements GlobalEnvironmentVariablesCubit {}

class MockGlobalEnvironmentVariablesState extends Mock implements GlobalEnvironmentVariablesState {}

class MockVariablesHandler extends Mock implements VariablesHandler {}

class MockScript extends Mock implements Script {}

class MockScriptsCubit extends MockCubit<ScriptsState> implements ScriptsCubit {}

class MockScriptsState extends Mock implements ScriptsState {}

class MockShell extends Mock implements Shell {}

class MockShellsCubit extends MockCubit<ShellsState> implements ShellsCubit {}

class MockShellsState extends Mock implements ShellsState {}

GitBranch mockGitBranch1 = MockGitBranch();
GitBranch mockGitBranch2 = MockGitBranch();
BranchVariable mockBranchVariable1 = MockBranchVariable();
BranchVariable mockBranchVariable2 = MockBranchVariable();
BranchVariableValue mockBranchVariableValue1 = MockBranchVariableValue();
BranchVariableValue mockBranchVariableValue2 = MockBranchVariableValue();
GlobalVariable mockGlobalVariable1 = MockGlobalVariable();
GlobalVariable mockGlobalVariable2 = MockGlobalVariable();
GlobalEnvironmentVariable mockGlobalEnvironmentVariable1 = MockGlobalEnvironmentVariable();
GlobalEnvironmentVariable mockGlobalEnvironmentVariable2 = MockGlobalEnvironmentVariable();
Shell mockShell1 = MockShell();
Shell mockShell2 = MockShell();
Script mockScript1 = MockScript();
Script mockScript1a = MockScript();
Script mockScript2 = MockScript();

void initMocks() {
  when(() => mockGitBranch1.uuid).thenReturn('a-uuid-1');
  when(() => mockGitBranch1.name).thenReturn('master');
  when(() => mockGitBranch1.directory).thenReturn('/home/user/src/project');
  when(() => mockGitBranch1.origin).thenReturn('git:someplace/bob');

  when(() => mockGitBranch2.uuid).thenReturn('a-uuid-2');
  when(() => mockGitBranch2.name).thenReturn('branch-one');
  when(() => mockGitBranch2.directory).thenReturn('/home/user/src/banch1');
  when(() => mockGitBranch2.origin).thenReturn('git:someplace/bob');

  when(() => mockBranchVariable1.uuid).thenReturn('v-uuid-1');
  when(() => mockBranchVariable1.name).thenReturn('variable1');
  when(() => mockBranchVariable1.defaultValue).thenReturn('default1');

  when(() => mockBranchVariable2.uuid).thenReturn('v-uuid-2');
  when(() => mockBranchVariable2.name).thenReturn('variable2');
  when(() => mockBranchVariable2.defaultValue).thenReturn('default2');

  when(() => mockBranchVariableValue1.uuid).thenReturn('bvv-uuid-1');
  when(() => mockBranchVariableValue1.branchUuid).thenReturn('a-uuid-1');
  when(() => mockBranchVariableValue1.variableUuid).thenReturn('v-uuid-1');
  when(() => mockBranchVariableValue1.value).thenReturn('start value 1');

  when(() => mockBranchVariableValue2.uuid).thenReturn('bvv-uuid-2');
  when(() => mockBranchVariableValue2.branchUuid).thenReturn('a-uuid-2');
  when(() => mockBranchVariableValue2.variableUuid).thenReturn('v-uuid-1');
  when(() => mockBranchVariableValue2.value).thenReturn('start value 2');

  when(() => mockGlobalVariable1.uuid).thenReturn('gv-uuid-1');
  when(() => mockGlobalVariable1.name).thenReturn('g-variable-1');
  when(() => mockGlobalVariable1.value).thenReturn('value1');

  when(() => mockGlobalVariable2.uuid).thenReturn('gv-uuid-2');
  when(() => mockGlobalVariable2.name).thenReturn('g-variable-2');
  when(() => mockGlobalVariable2.value).thenReturn('value2');

  when(() => mockGlobalEnvironmentVariable1.uuid).thenReturn('ge-uuid-1');
  when(() => mockGlobalEnvironmentVariable1.name).thenReturn('g-env-1');
  when(() => mockGlobalEnvironmentVariable1.value).thenReturn('value1');

  when(() => mockGlobalEnvironmentVariable2.uuid).thenReturn('ge-uuid-2');
  when(() => mockGlobalEnvironmentVariable2.name).thenReturn('g-env-2');
  when(() => mockGlobalEnvironmentVariable2.value).thenReturn('value2');

  when(() => mockShell1.uuid).thenReturn('sh-uuid-1');
  when(() => mockShell1.command).thenReturn('/usr/bin/bash');
  when(() => mockShell1.args).thenReturn(['arg1', 'arg2']);

  when(() => mockShell2.uuid).thenReturn('sh-uuid-2');
  when(() => mockShell2.command).thenReturn('/usr/bin/zsh');
  when(() => mockShell2.args).thenReturn([]);

  when(() => mockScript1.uuid).thenReturn('s-uuid-1');
  when(() => mockScript1.shellUuid).thenReturn('sh-uuid-1');
  when(() => mockScript1.name).thenReturn('script-1');
  when(() => mockScript1.command).thenReturn('command-1');
  when(() => mockScript1.workingDirectory).thenReturn('/working/dir/1');
  when(() => mockScript1.runInDocker).thenReturn(false);
  when(() => mockScript1.args).thenReturn(
    [
      'arg-1',
      'arg-2',
      'arg-3',
    ],
  );
  when(() => mockScript1.envVars).thenReturn(
    {
      'env-1': 'env-value-1',
      'env-2': 'env-value-2',
    },
  );

  when(() => mockScript1a.uuid).thenReturn('s-uuid-1');
  when(() => mockScript1a.shellUuid).thenReturn('sh-uuid-3');
  when(() => mockScript1a.name).thenReturn('script-2');
  when(() => mockScript1a.command).thenReturn('command-3');
  when(() => mockScript1a.workingDirectory).thenReturn('/working/dir/4');
  when(() => mockScript1a.runInDocker).thenReturn(false);
  when(() => mockScript1a.args).thenReturn([]);
  when(() => mockScript1a.envVars).thenReturn({});

  when(() => mockScript2.uuid).thenReturn('s-uuid-2');
  when(() => mockScript2.shellUuid).thenReturn('sh-uuid-2');
  when(() => mockScript2.name).thenReturn('script-2');
  when(() => mockScript2.command).thenReturn('command-2');
  when(() => mockScript2.workingDirectory).thenReturn('/working/dir/2');
  when(() => mockScript2.runInDocker).thenReturn(true);
  when(() => mockScript2.args).thenReturn(
    [
      'arg-1',
      'arg-2',
    ],
  );
  when(() => mockScript2.envVars).thenReturn(
    {
      'env-1': 'env-value-1',
      'env-2': 'env-value-2',
      'env-3': 'env-value-3',
    },
  );
}

FileSystem mockDataStoreRepositoryJsonFile() {
  final mockFileSystem = MockFileSystem();

  final mockFile = MockFile();

  when(mockFile.readAsStringSync).thenReturn(fileContents);
  when(mockFile.readAsString).thenAnswer((_) => Future.value(fileContents));

  when(() => mockFileSystem.isFileSync('a-file.json')).thenReturn(true);
  when(() => mockFileSystem.file('a-file.json')).thenReturn(mockFile);
  return mockFileSystem;
}
