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
  VariablesState({
    required this.dataStoreRepository,
    this.status = VariablesStatus.initial,
    List<Variable>? variables,
  }) {
    dataStoreRepository.variables = variables ?? [];
  }

  final VariablesStatus status;
  final DataStoreRepository dataStoreRepository;

  List<Variable> get variables => dataStoreRepository.variables;

  VariablesState copyWith({required VariablesStatus status, List<Variable>? variables}) {
    return VariablesState(
      dataStoreRepository: dataStoreRepository,
      status: status,
      variables: variables ?? dataStoreRepository.variables,
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

  VariablesState load() {
    return copyWith(
      status: VariablesStatus.loaded,
      variables: List.from(variables),
    );
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
      variables: dataStoreRepository.addVariable(variable),
    );
  }

  VariablesState delete(Variable variable) {
    if (_findVariableUUID(variable.uuid) != variable) {
      return copyWith(status: VariablesStatus.deleteFailedNotFound);
    }

    return copyWith(
      status: VariablesStatus.deleted,
      variables: dataStoreRepository.deleteVariable(variable),
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
