part of 'global_environment_variables_cubit.dart';

enum GlobalEnvironmentVariablesStatus { initial, loaded, changing, saved, added, addFailedUUIDExists, addFailedNameExists, deleted, deleteFailedNotFound, failure, updateFailedUUIDNotFound, updated }

extension VariablesStatusX on GlobalEnvironmentVariablesStatus {
  bool get isInitial => this == GlobalEnvironmentVariablesStatus.initial;
  bool get isChanging => this == GlobalEnvironmentVariablesStatus.changing;
  bool get isSaved => this == GlobalEnvironmentVariablesStatus.saved;
  bool get isLoaded => this == GlobalEnvironmentVariablesStatus.loaded;
  bool get isAdded => this == GlobalEnvironmentVariablesStatus.added;
  bool get isAddFailedUUIDExists => this == GlobalEnvironmentVariablesStatus.addFailedUUIDExists;
  bool get isAddFailedNameExists => this == GlobalEnvironmentVariablesStatus.addFailedNameExists;
  bool get isDeleted => this == GlobalEnvironmentVariablesStatus.deleted;
  bool get isDeleteFailedNotFound => this == GlobalEnvironmentVariablesStatus.deleteFailedNotFound;
  bool get isFailure => this == GlobalEnvironmentVariablesStatus.failure;
  bool get isUpdateFailedUUIDNotFound => this == GlobalEnvironmentVariablesStatus.updateFailedUUIDNotFound;
  bool get isUpdated => this == GlobalEnvironmentVariablesStatus.updated;
}

class GlobalEnvironmentVariablesState extends Equatable {
  GlobalEnvironmentVariablesState({
    required this.dataStoreRepository,
    this.status = GlobalEnvironmentVariablesStatus.initial,
    List<GlobalEnvironmentVariable>? variables,
  }) {
    if (variables != null) {
      dataStoreRepository.globalEnvironmentVariables = variables;
    }
  }

  final GlobalEnvironmentVariablesStatus status;
  final DataStoreRepository dataStoreRepository;

  List<GlobalEnvironmentVariable> get variables => dataStoreRepository.globalEnvironmentVariables;

  GlobalEnvironmentVariablesState copyWith({required GlobalEnvironmentVariablesStatus status, List<GlobalEnvironmentVariable>? variables}) {
    return GlobalEnvironmentVariablesState(
      dataStoreRepository: dataStoreRepository,
      status: status,
      variables: variables ?? dataStoreRepository.globalEnvironmentVariables,
    );
  }

  GlobalEnvironmentVariable? _findVariableUUID(String uuid) {
    for (final variable in variables) {
      if (uuid == variable.uuid) {
        return variable;
      }
    }
    return null;
  }

  GlobalEnvironmentVariable? _findVariableName(String name) {
    for (final variable in variables) {
      if (name == variable.name) {
        return variable;
      }
    }
    return null;
  }

  GlobalEnvironmentVariablesState load() {
    return copyWith(
      status: GlobalEnvironmentVariablesStatus.loaded,
      variables: List.from(dataStoreRepository.globalEnvironmentVariables),
    );
  }

  GlobalEnvironmentVariablesState add(GlobalEnvironmentVariable variable) {
    if (_findVariableUUID(variable.uuid) != null) {
      return copyWith(status: GlobalEnvironmentVariablesStatus.addFailedUUIDExists);
    }

    if (_findVariableName(variable.name) != null) {
      return copyWith(status: GlobalEnvironmentVariablesStatus.addFailedNameExists);
    }

    return copyWith(
      status: GlobalEnvironmentVariablesStatus.added,
      variables: dataStoreRepository.addGlobalEnvironmentVariable(variable),
    );
  }

  GlobalEnvironmentVariablesState delete(GlobalEnvironmentVariable variable) {
    if (_findVariableUUID(variable.uuid) != variable) {
      return copyWith(status: GlobalEnvironmentVariablesStatus.deleteFailedNotFound);
    }

    return copyWith(
      status: GlobalEnvironmentVariablesStatus.deleted,
      variables: dataStoreRepository.deleteGlobalEnvironmentVariable(variable),
    );
  }

  @override
  List<Object?> get props => [status, variables];

  GlobalEnvironmentVariable? getVariable(String uuid) {
    for (final variable in variables) {
      if (uuid == variable.uuid) {
        return variable;
      }
    }
    return null;
  }

  GlobalEnvironmentVariablesState changing() {
    return copyWith(status: GlobalEnvironmentVariablesStatus.changing);
  }

  GlobalEnvironmentVariablesState update(GlobalEnvironmentVariable newValue) {
    final existing = _findVariableUUID(newValue.uuid);
    if (existing != null) {
      final index = variables.indexOf(existing);

      return copyWith(
        status: GlobalEnvironmentVariablesStatus.updated,
        variables: List.from(variables)..replaceRange(index, index + 1, [newValue]),
      );
    }
    return copyWith(status: GlobalEnvironmentVariablesStatus.updateFailedUUIDNotFound);
  }
}
