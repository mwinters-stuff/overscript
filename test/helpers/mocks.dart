import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:file/file.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/variable/variable.dart';
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

class MockVariable extends Mock implements Variable {}

class MockVariablesCubit extends MockCubit<VariablesState> implements VariablesCubit {}

class MockVariablesState extends Mock implements VariablesState {}

class MockFileSystem extends Mock implements FileSystem {}

class MockFile extends Mock implements File {}

class MockProcessManager extends Mock implements ProcessManager {}

class MockProcessResult extends Mock implements ProcessResult {}