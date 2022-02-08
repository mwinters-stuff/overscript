part of 'variables_cubit.dart';

enum VariablesStatus { initial, loaded, changing, saved, added, addFailedUUIDExists, addFailedNameExists, deleted, deleteFailedNotFound, failure }

extension VariablesStatusX on VariablesStatus {
  bool get isInitial => this == VariablesStatus.initial;
  bool get isChanging => this == VariablesStatus.changing;
  bool get isSaved => this == VariablesStatus.saved;
  bool get isLoaded => this == VariablesStatus.loaded;
  bool get isAdded => this == VariablesStatus.added;
  bool get isAddFailedUUIDExists => this == VariablesStatus.addFailedUUIDExists;
  bool get isAddFailedNameExists => this == VariablesStatus.addFailedNameExists;
  bool get isDeleted => this == VariablesStatus.deleted;
  bool get isDeleteFailedNotFound => this == VariablesStatus.deleteFailedNotFound;
  bool get isFailure => this == VariablesStatus.failure;
}

class VariablesState extends Equatable {
  VariablesState({this.status = VariablesStatus.initial, List<Variable>? variables}) : variables = variables ?? [];

  final List<Variable> variables;
  final VariablesStatus status;

  VariablesState copyWith({required VariablesStatus status, List<Variable>? variables}) {
    return VariablesState(
      status: status,
      variables: variables ?? this.variables,
    );
  }

  Variable? _findVariableUUID(String uuid) {
    for (final variable in variables) {
      if (uuid == variable.uuid) {
        return variable;
      }
    }
    return null;
  }

  Variable? _findVariableName(String name) {
    for (final variable in variables) {
      if (name == variable.name) {
        return variable;
      }
    }
    return null;
  }

  VariablesState load(DataStoreRepository dataStoreRepository) {
    return copyWith(
      status: VariablesStatus.loaded,
      variables: List.from(dataStoreRepository.variables, growable: true),
    );
  }

  VariablesState save(DataStoreRepository dataStoreRepository) {
    dataStoreRepository.variables = variables;
    return copyWith(status: VariablesStatus.saved);
  }

  VariablesState add(Variable variable) {
    if (_findVariableUUID(variable.uuid) != null) {
      return copyWith(status: VariablesStatus.addFailedUUIDExists);
    }

    if (_findVariableName(variable.name) != null) {
      return copyWith(status: VariablesStatus.addFailedNameExists);
    }

    return copyWith(
      status: VariablesStatus.added,
      variables: List.from(variables)..add(variable),
    );
  }

  VariablesState delete(Variable variable) {
    if (_findVariableUUID(variable.uuid) != variable) {
      return copyWith(status: VariablesStatus.deleteFailedNotFound);
    }
    return copyWith(
      status: VariablesStatus.deleted,
      variables: List.from(variables)..removeWhere((element) => element.uuid == variable.uuid),
    );
  }

  @override
  List<Object?> get props => [status, variables];

  Variable? getVariable(String uuid) {
    for (final variable in variables) {
      if (uuid == variable.uuid) {
        return variable;
      }
    }
    return null;
  }

  VariablesState changing() {
    return copyWith(status: VariablesStatus.changing);
  }
}
