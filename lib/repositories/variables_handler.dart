import 'dart:io';

import 'package:interpolation/interpolation.dart';
import 'package:overscript/repositories/data_store_repository.dart';

class VariablesHandler {
  VariablesHandler(this.dataStoreRepository);

  DataStoreRepository dataStoreRepository;
  final _envVars = {
    'HOME',
    'USERNAME',
  };

  Map<String, String> _cleanEnvironment() {
    final result = <String, String>{};
    for (final entry in Platform.environment.entries) {
      if (entry.value.isNotEmpty && _envVars.contains(entry.key)) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  String suggestBaseVariables(String inputString) {
    var resultString = inputString;
    final allVariables = _cleanEnvironment();
    for (final variable in allVariables.entries) {
      if (resultString.contains(variable.value)) {
        resultString = resultString.replaceAll(variable.value, '{${variable.key}}');
      }
    }
    return resultString;
  }

  String suggestVariables(String inputString) {
    var resultString = inputString;
    final allVariables = <String, String>{}
      ..addAll(dataStoreRepository.suggestiveVariables)
      ..addAll(_cleanEnvironment());
    for (final variable in allVariables.entries) {
      if (resultString.contains(variable.value)) {
        resultString = resultString.replaceAll(variable.value, '{${variable.key}}');
      }
    }
    return resultString;
  }

  String suggestGitOrHomePath(String inputString) {
    for (final path in dataStoreRepository.getGitBranchRoots()) {
      if (inputString.startsWith(path)) {
        return inputString.replaceAll(path, '{GITROOT}');
      }
    }
    if (Platform.environment['HOME'] != null) {
      if (inputString.startsWith(Platform.environment['HOME']!)) {
        return inputString.replaceAll(Platform.environment['HOME']!, '{HOME}');
      }
    }
    return inputString;
  }

  String replaceVariables(String inputString, String branchUuid) {
    final variableValues = {}
      ..addAll(_cleanEnvironment())
      ..addAll(dataStoreRepository.variableValues[branchUuid]!);
    return Interpolation().eval(inputString, variableValues, true);
  }
}
