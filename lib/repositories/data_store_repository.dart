import 'dart:convert';

import 'package:file/file.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';
import 'package:overscript/global_variable/global_variable.dart';
import 'package:overscript/repositories/json_storage.dart';
import 'package:overscript/scripts/scripts.dart';
import 'package:overscript/shells/shells.dart';
import 'package:uuid/uuid.dart';

class DataStoreRepository {
  DataStoreRepository(this.fileSystem)
      : gitBranches = [],
        shells = [],
        scripts = [],
        branchVariables = [],
        branchVariableValues = [],
        globalVariables = [],
        globalEnvironmentVariables = [];

  final FileSystem fileSystem;
  List<Shell> shells;
  List<Script> scripts;
  List<BranchVariable> branchVariables;
  List<GitBranch> gitBranches;
  List<BranchVariableValue> branchVariableValues;
  List<GlobalVariable> globalVariables;
  List<GlobalEnvironmentVariable> globalEnvironmentVariables;

  final Map<String, String> suggestiveVariables = {};
  final Map<String, Map<String, String>> variableValues = {};

  void _buildVariablesMaps() {
    suggestiveVariables.clear();
    final globalVariableValues = <String, String>{};

    for (final variable in globalVariables) {
      suggestiveVariables.putIfAbsent(variable.name, () => variable.value);
      globalVariableValues.putIfAbsent(variable.name, () => variable.value);
    }

    for (final branchVariableValue in branchVariableValues) {
      final branchVariable = getBranchVariable(branchVariableValue.variableUuid);
      suggestiveVariables.putIfAbsent(branchVariable.name, () => branchVariableValue.value);
    }

    variableValues.clear();

    for (final branch in gitBranches) {
      variableValues[branch.uuid] = Map.from(globalVariableValues).cast();

      for (final branchVariable in branchVariables) {
        final branchVariableValue = branchVariableValues.firstWhere(
          (element) => element.branchUuid == branch.uuid && element.variableUuid == branchVariable.uuid,
          orElse: () => BranchVariableValue(
            uuid: 'uuid',
            branchUuid: branch.uuid,
            variableUuid: branchVariable.uuid,
            value: branchVariable.defaultValue,
          ),
        );

        variableValues[branch.uuid]!.putIfAbsent(branchVariable.name, () => branchVariableValue.value);
      }
    }
  }

  Future<bool> load(String filename) async {
    if (fileSystem.isFileSync(filename)) {
      final file = fileSystem.file(filename);
      final content = await file.readAsString();
      final jsonStorage = JsonStorage.fromJson(
        const JsonDecoder().convert(content) as Map<String, dynamic>,
      );
      shells = List.from(jsonStorage.shells, growable: true);
      scripts = List.from(jsonStorage.scripts, growable: true);
      branchVariables = List.from(jsonStorage.branchVariables, growable: true);
      gitBranches = List.from(jsonStorage.gitBranches, growable: true);
      branchVariableValues = List.from(jsonStorage.branchVariableValues, growable: true);
      globalVariables = List.from(jsonStorage.globalVariables, growable: true);
      globalEnvironmentVariables = List.from(jsonStorage.globalEnvironmentVariables, growable: true);
      _buildVariablesMaps();
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<bool> save(String filename) async {
    final jsonStorage = JsonStorage(
      shells: shells,
      scripts: scripts,
      branchVariables: branchVariables,
      gitBranches: gitBranches,
      branchVariableValues: branchVariableValues,
      globalVariables: globalVariables,
      globalEnvironmentVariables: globalEnvironmentVariables,
    );
    final output = const JsonEncoder.withIndent('  ').convert(jsonStorage);
    await fileSystem.file(filename).writeAsString(output);
    _buildVariablesMaps();
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

  List<String> getGitBranchRoots() {
    final result = <String>[];

    for (final branch in gitBranches) {
      result.add(branch.directory);
    }
    return result;
  }

  List<Script> addScript(Script script) {
    return List.from(scripts)..add(script);
  }

  List<Script> deleteScript(Script script) {
    // delete branch values
    return List.from(scripts)..removeWhere((element) => element.uuid == script.uuid);
  }

  List<Shell> addShell(Shell shell) {
    return List.from(shells)..add(shell);
  }

  List<Shell> deleteShell(Shell shell) {
    // delete branch values
    return List.from(shells)..removeWhere((element) => element.uuid == shell.uuid);
  }
}
