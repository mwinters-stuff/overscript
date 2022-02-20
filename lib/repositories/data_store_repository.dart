import 'dart:convert';

import 'package:file/file.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/global_variable/global_variable.dart';
import 'package:overscript/repositories/json_storage.dart';
import 'package:uuid/uuid.dart';

class DataStoreRepository {
  DataStoreRepository(this.fileSystem)
      : branches = [],
        scripts = [],
        branchVariables = [],
        branchVariableValues = [],
        globalVariables = [];

  final FileSystem fileSystem;
  List<dynamic> scripts;
  List<BranchVariable> branchVariables;
  List<GitBranch> branches;
  List<BranchVariableValue> branchVariableValues;
  List<GlobalVariable> globalVariables;

  Future<bool> load(String filename) async {
    if (fileSystem.isFileSync(filename)) {
      final file = fileSystem.file(filename);
      final content = await file.readAsString();
      final jsonStorage = JsonStorage.fromJson(
        const JsonDecoder().convert(content) as Map<String, dynamic>,
      );
      scripts = List.from(jsonStorage.scripts, growable: true);
      branchVariables = List.from(jsonStorage.branchVariables, growable: true);
      branches = List.from(jsonStorage.branches, growable: true);
      branchVariableValues = List.from(jsonStorage.branchVariableValues, growable: true);
      globalVariables = List.from(jsonStorage.globalVariables, growable: true);
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<bool> save(String filename) async {
    final jsonStorage = JsonStorage(scripts: scripts, branchVariables: branchVariables, branches: branches, branchVariableValues: branchVariableValues, globalVariables: globalVariables);
    final output = const JsonEncoder.withIndent('  ').convert(jsonStorage);
    await fileSystem.file(filename).writeAsString(output);
    return Future.value(true);
  }

  List<BranchVariable> addBranchVariable(BranchVariable variable) {
    // add variable values for each branch.
    for (final branch in branches) {
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

  List<GlobalVariable> addGlobalVariable(GlobalVariable variable) {
    return List.from(globalVariables)..add(variable);
  }

  List<GlobalVariable> deleteGlobalVariable(GlobalVariable variable) {
    // delete branch values
    return List.from(globalVariables)..removeWhere((element) => element.uuid == variable.uuid);
  }

  List<GitBranch> addBranch(GitBranch branch) {
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

    return List.from(branches)..add(branch);
  }

  List<GitBranch> deleteBranch(GitBranch branch) {
    // delete branch values
    branchVariableValues.removeWhere((element) => element.branchUuid == branch.uuid);
    return List.from(branches)..removeWhere((element) => element.uuid == branch.uuid);
  }
}
