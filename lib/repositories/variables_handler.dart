import 'package:interpolation/interpolation.dart';
import 'package:overscript/repositories/data_store_repository.dart';

class VariablesHandler {
  VariablesHandler(this.dataStoreRepository);

  DataStoreRepository dataStoreRepository;

  String suggestVariables(String inputString) {
    var resultString = inputString;
    for (final variable in dataStoreRepository.globalVariables) {
      if (resultString.contains(variable.value)) {
        resultString = resultString.replaceAll(variable.value, '{${variable.name}}');
      }
    }
    for (final branchVariableValue in dataStoreRepository.branchVariableValues) {
      if (resultString.contains(branchVariableValue.value)) {
        final branchVariable = dataStoreRepository.getBranchVariable(branchVariableValue.variableUuid);
        resultString = resultString.replaceAll(branchVariableValue.value, '{${branchVariable.name}}');
      }
    }
    return resultString;
  }

  String replaceVariables(String inputString, String branchUuid) {
    final variableValues = dataStoreRepository.getVariableValues(branchUuid);
    return Interpolation().eval(inputString, variableValues);
  }
}
