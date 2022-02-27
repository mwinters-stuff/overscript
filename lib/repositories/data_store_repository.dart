import 'dart:convert';

import 'package:file/file.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';
import 'package:overscript/global_variable/global_variable.dart';
import 'package:overscript/repositories/json_storage.dart';
import 'package:uuid/uuid.dart';

class DataStoreRepository {
  DataStoreRepository(this.fileSystem)
      : gitBranches = [],
        scripts = [],
        branchVariables = [],
        branchVariableValues = [],
        globalVariables = [],
        globalEnvironmentVariables = [];

  final FileSystem fileSystem;
  List<dynamic> scripts;
  List<BranchVariable> branchVariables;
  List<GitBranch> gitBranches;
  List<BranchVariableValue> branchVariableValues;
  List<GlobalVariable> globalVariables;
  List<GlobalEnvironmentVariable> globalEnvironmentVariables;

  Future<bool> load(String filename) async {
    if (fileSystem.isFileSync(filename)) {
      final file = fileSystem.file(filename);
      final content = await file.readAsString();
      final jsonStorage = JsonStorage.fromJson(
        const JsonDecoder().convert(content) as Map<String, dynamic>,
      );
      scripts = List.from(jsonStorage.scripts, growable: true);
      branchVariables = List.from(jsonStorage.branchVariables, growable: true);
      gitBranches = List.from(jsonStorage.gitBranches, growable: true);
      branchVariableValues = List.from(jsonStorage.branchVariableValues, growable: true);
      globalVariables = List.from(jsonStorage.globalVariables, growable: true);
      globalEnvironmentVariables = List.from(jsonStorage.globalEnvironmentVariables, growable: true);
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<bool> save(String filename) async {
    final jsonStorage = JsonStorage(
      scripts: scripts,
      branchVariables: branchVariables,
      gitBranches: gitBranches,
      branchVariableValues: branchVariableValues,
      globalVariables: globalVariables,
      globalEnvironmentVariables: globalEnvironmentVariables,
    );
    final output = const JsonEncoder.withIndent('  ').convert(jsonStorage);
    await fileSystem.file(filename).writeAsString(output);
    return Future.value(true);
  }

  List<BranchVariable> addBranchVariable(BranchVariable variable) {
    // add variable values for each branch.
    for (final branch in gitBranches) {
      branchVariableValues.add(
        BranchVariableValue(
          uuid: const Uuid().v1(),
          branchUuid: branch.uuid,
          variableUuid: variable.uuid,
          value: variable.defaultValue,
        ),
      );
    }

    return List.from(branchVariables)..add(variable);
  }

  List<BranchVariable> deleteBranchVariable(BranchVariable variable) {
    // delete branch values
    branchVariableValues.removeWhere((element) => element.variableUuid == variable.uuid);
    return List.from(branchVariables)..removeWhere((element) => element.uuid == variable.uuid);
  }

  List<GitBranch> addGitBranch(GitBranch branch) {
    // add variable values for each branch.
    for (final variable in branchVariables) {
      branchVariableValues.add(
        BranchVariableValue(
          uuid: const Uuid().v1(),
          branchUuid: branch.uuid,
          variableUuid: variable.uuid,
          value: variable.defaultValue,
        ),
      );
    }

    return List.from(gitBranches)..add(branch);
  }

  List<GitBranch> deleteGitBranch(GitBranch branch) {
    // delete branch values
    branchVariableValues.removeWhere((element) => element.branchUuid == branch.uuid);
    return List.from(gitBranches)..removeWhere((element) => element.uuid == branch.uuid);
  }

  List<GlobalVariable> addGlobalVariable(GlobalVariable variable) {
    return List.from(globalVariables)..add(variable);
  }

  List<GlobalVariable> deleteGlobalVariable(GlobalVariable variable) {
    // delete branch values
    return List.from(globalVariables)..removeWhere((element) => element.uuid == variable.uuid);
  }

  List<GlobalEnvironmentVariable> addGlobalEnvironmentVariable(GlobalEnvironmentVariable variable) {
    return List.from(globalEnvironmentVariables)..add(variable);
  }

  List<GlobalEnvironmentVariable> deleteGlobalEnvironmentVariable(GlobalEnvironmentVariable variable) {
    // delete branch values
    return List.from(globalEnvironmentVariables)..removeWhere((element) => element.uuid == variable.uuid);
  }

  BranchVariable getBranchVariable(String variableUuid) {
    return branchVariables.firstWhere((element) => element.uuid == variableUuid);
  }

  Map<String, String> getVariableValues(String branchUuid) {
    final variableValues = <String, String>{};

    for (final element in globalVariables) {
      variableValues.putIfAbsent(element.name, () => element.value);
    }

    for (final branchVariable in branchVariables) {
      final branchVariableValue = branchVariableValues.firstWhere(
        (element) => element.branchUuid == branchUuid && element.variableUuid == branchVariable.uuid,
        orElse: () => BranchVariableValue(
          uuid: 'uuid',
          branchUuid: branchUuid,
          variableUuid: branchVariable.uuid,
          value: branchVariable.defaultValue,
        ),
      );

      variableValues.putIfAbsent(branchVariable.name, () => branchVariableValue.value);
    }

    return variableValues;
  }
}
