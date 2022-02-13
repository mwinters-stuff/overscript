import 'dart:convert';
import 'dart:io';

import 'package:file/file.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/gitbranch/cubit/gitbranch.dart';
import 'package:overscript/repositories/json_storage.dart';
import 'package:overscript/variable/variable.dart';
import 'package:uuid/uuid.dart';

class DataStoreRepository {
  DataStoreRepository(this.fileSystem)
      : branches = [],
        scripts = [],
        variables = [],
        branchVariableValues = [];

  final FileSystem fileSystem;
  List<dynamic> scripts;
  List<Variable> variables;
  List<GitBranch> branches;
  List<BranchVariableValue> branchVariableValues;

  Future<bool> load(String filename) async {
    if (fileSystem.isFileSync(filename)) {
      final file = fileSystem.file(filename);
      final content = await file.readAsString();
      final jsonStorage = JsonStorage.fromJson(
        const JsonDecoder().convert(content) as Map<String, dynamic>,
      );
      scripts = List.from(jsonStorage.scripts, growable: true);
      variables = List.from(jsonStorage.variables, growable: true);
      branches = List.from(jsonStorage.branches, growable: true);
      branchVariableValues = List.from(jsonStorage.branchVariableValues, growable: true);
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<bool> save(String filename) async {
    final jsonStorage = JsonStorage(scripts: scripts, variables: variables, branches: branches, branchVariableValues: branchVariableValues);
    final output = const JsonEncoder.withIndent('  ').convert(jsonStorage);
    await fileSystem.file(filename).writeAsString(output);
    return Future.value(true);
  }

  List<Variable> addVariable(Variable variable) {
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

    return List.from(variables)..add(variable);
  }

  List<Variable> deleteVariable(Variable variable) {
    // delete branch values
    branchVariableValues.removeWhere((element) => element.variableUuid == variable.uuid);
    return List.from(variables)..removeWhere((element) => element.uuid == variable.uuid);
  }

  List<GitBranch> addBranch(GitBranch branch) {
    // add variable values for each branch.
    for (final variable in variables) {
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
