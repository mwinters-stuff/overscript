import 'dart:convert';
import 'dart:io';

import 'package:file/file.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/gitbranch/cubit/gitbranch.dart';
import 'package:overscript/repositories/json_storage.dart';
import 'package:overscript/variable/variable.dart';

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

  // String? checkScriptNameUsed(String name) {
  //   for (var script in _scripts) {
  //     if (name == script.name) {
  //       return script.uuid;
  //     }
  //   }
  //   return null;
  // }

  // String? checkVariableNameUsed(String name) {
  //   for (var variable in _variables) {
  //     if (name == variable.name) {
  //       return variable.uuid;
  //     }
  //   }
  //   return null;
  // }

  // // check branch names before directory.
  // String? checkBranchNameOrDirectoryUsed(String name, String directory) {
  //   for (var branch in _branches) {
  //     if (name == branch.name) {
  //       return branch.uuid;
  //     }
  //   }
  //   for (var branch in _branches) {
  //     if (directory == branch.directory) {
  //       return branch.uuid;
  //     }
  //   }
  //   return null;
  // }

  void load(String filename) {
    if (fileSystem.isFileSync(filename)) {
      final file = fileSystem.file(filename);
      final content = file.readAsStringSync();
      final jsonStorage = JsonStorage.fromJson(
        const JsonDecoder().convert(content) as Map<String, dynamic>,
      );
      scripts = List.from(jsonStorage.scripts, growable: true);
      variables = List.from(jsonStorage.variables, growable: true);
      branches = List.from(jsonStorage.branches, growable: true);
      branchVariableValues = List.from(jsonStorage.branchVariableValues, growable: true);
    }
  }

  void save(String filename) {
    final jsonStorage = JsonStorage(scripts: scripts, variables: variables, branches: branches, branchVariableValues: branchVariableValues);
    final output = const JsonEncoder.withIndent('  ').convert(jsonStorage);
    fileSystem.file(filename).writeAsStringSync(output);
  }

  // StoredScript? getScript(String uuid) {
  //   try {
  //     return _scripts.firstWhere((element) => element.uuid == uuid);
  //   } on StateError catch (_, __) {
  //     return null;
  //   }
  // }

  // StoredVariable? getVariable(String uuid) {
  //   try {
  //     return _variables.firstWhere((element) => element.uuid == uuid);
  //   } on StateError catch (_, __) {
  //     return null;
  //   }
  // }

  // StoredBranch? getBranch(String uuid) {
  //   try {
  //     return _branches.firstWhere((element) => element.uuid == uuid);
  //   } on StateError catch (_, __) {
  //     return null;
  //   }
  // }

  // List<StoredBranchVariable> getBranchVariables(String branchUuid) {
  //   List<StoredBranchVariable> result = [];
  //   for (StoredVariable variable in _variables) {
  //     for (StoredBranchVariable branchVariable in variable.branchValues) {
  //       if (branchVariable.branchUuid == branchUuid) {
  //         result.add(branchVariable);
  //       }
  //     }
  //   }
  //   return result;
  // }

  // bool addScript(
  //     {required String uuid,
  //     required String name,
  //     required String command,
  //     required List<String> args,
  //     required String workingDirectory,
  //     required bool runInDocker,
  //     required List<StringPair> envVars}) {
  //   if (checkScriptNameUsed(name) == null) {
  //     _scripts.add(StoredScript(uuid: uuid, name: name, command: command, args: args, workingDirectory: workingDirectory, runInDocker: runInDocker, envVars: envVars));
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // bool editScript(
  //     {required String uuid,
  //     required String name,
  //     required String command,
  //     required List<String> args,
  //     required String workingDirectory,
  //     required bool runInDocker,
  //     required List<StringPair> envVars}) {
  //   String? usedUuid = checkScriptNameUsed(name);
  //   if (usedUuid == null || usedUuid == uuid) {
  //     deleteScript(uuid);
  //     _scripts.add(StoredScript(uuid: uuid, name: name, command: command, args: args, workingDirectory: workingDirectory, runInDocker: runInDocker, envVars: envVars));
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // void deleteScript(String uuid) {
  //   _scripts.removeWhere((element) => element.uuid == uuid);
  // }

  // void addVariable({required String uuid, required String name, required List<StoredBranchVariable> branchValues}) {
  //   if (checkVariableNameUsed(name) == null) {
  //     _variables.add(StoredVariable(uuid: uuid, name: name, branchValues: branchValues));
  //   }
  // }

  // void editVariable({required String uuid, required String name, required List<StoredBranchVariable> branchValues}) {
  //   String? usedUuid = checkVariableNameUsed(name);
  //   if (usedUuid == null || usedUuid == uuid) {
  //     deleteVariable(uuid);
  //     _variables.add(StoredVariable(uuid: uuid, name: name, branchValues: branchValues));
  //   }
  // }

  // void deleteVariable(String uuid) {
  //   _variables.removeWhere((element) => element.uuid == uuid);
  // }

  // void addBranch({required String uuid, required String name, required String directory}) {
  //   if (checkBranchNameOrDirectoryUsed(name, directory) == null) {
  //     _branches.add(StoredBranch(uuid: uuid, name: name, directory: directory));
  //     for (var variable in _variables) {
  //       variable.branchValues.add(StoredBranchVariable(branchUuid: uuid, value: ''));
  //     }
  //   }
  // }

  // void editBranch({required String uuid, required String name, required String directory}) {
  //   String? usedUuid = checkBranchNameOrDirectoryUsed(name, directory);
  //   if (usedUuid == null || usedUuid == uuid) {
  //     _branches.removeWhere((element) => element.uuid == uuid);
  //     _branches.add(StoredBranch(uuid: uuid, name: name, directory: directory));
  //   }
  // }

  // void deleteBranch(String uuid) {
  //   for (var variable in _variables) {
  //     variable.branchValues.removeWhere((element) => element.branchUuid == uuid);
  //   }

  //   _branches.removeWhere((element) => element.uuid == uuid);
  // }

}
