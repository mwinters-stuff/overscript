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
import 'package:process/process.dart';

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
