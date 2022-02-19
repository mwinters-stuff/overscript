part of 'global_variables_cubit.dart';

enum GlobalVariablesStatus { initial, loaded, changing, saved, added, addFailedUUIDExists, addFailedNameExists, deleted, deleteFailedNotFound, failure, updateFailedUUIDNotFound, updated }

extension VariablesStatusX on GlobalVariablesStatus {
  bool get isInitial => this == GlobalVariablesStatus.initial;
  bool get isChanging => this == GlobalVariablesStatus.changing;
  bool get isSaved => this == GlobalVariablesStatus.saved;
  bool get isLoaded => this == GlobalVariablesStatus.loaded;
  bool get isAdded => this == GlobalVariablesStatus.added;
  bool get isAddFailedUUIDExists => this == GlobalVariablesStatus.addFailedUUIDExists;
  bool get isAddFailedNameExists => this == GlobalVariablesStatus.addFailedNameExists;
  bool get isDeleted => this == GlobalVariablesStatus.deleted;
  bool get isDeleteFailedNotFound => this == GlobalVariablesStatus.deleteFailedNotFound;
  bool get isFailure => this == GlobalVariablesStatus.failure;
  bool get isUpdateFailedUUIDNotFound => this == GlobalVariablesStatus.updateFailedUUIDNotFound;
  bool get isUpdated => this == GlobalVariablesStatus.updated;
}

class GlobalVariablesState extends Equatable {
  GlobalVariablesState({
    required this.dataStoreRepository,
    this.status = GlobalVariablesStatus.initial,
    List<GlobalVariable>? variables,
  }) {
    if (variables != null) {
      dataStoreRepository.globalVariables = variables;
    }
  }

  final GlobalVariablesStatus status;
  final DataStoreRepository dataStoreRepository;

  List<GlobalVariable> get variables => dataStoreRepository.globalVariables;

  GlobalVariablesState copyWith({required GlobalVariablesStatus status, List<GlobalVariable>? variables}) {
    return GlobalVariablesState(
      dataStoreRepository: dataStoreRepository,
      status: status,
      variables: variables ?? dataStoreRepository.globalVariables,
    );
  }

  GlobalVariable? _findVariableUUID(String uuid) {
    for (final variable in variables) {
      if (uuid == variable.uuid) {
        return variable;
      }
    }
    return null;
  }

  GlobalVariable? _findVariableName(String name) {
    for (final variable in variables) {
      if (name == variable.name) {
        return variable;
      }
    }
    return null;
  }

  GlobalVariablesState load() {
    return copyWith(
      status: GlobalVariablesStatus.loaded,
      variables: List.from(dataStoreRepository.globalVariables),
    );
  }

  GlobalVariablesState add(GlobalVariable variable) {
    if (_findVariableUUID(variable.uuid) != null) {
      return copyWith(status: GlobalVariablesStatus.addFailedUUIDExists);
    }

    if (_findVariableName(variable.name) != null) {
      return copyWith(status: GlobalVariablesStatus.addFailedNameExists);
    }

    return copyWith(
      status: GlobalVariablesStatus.added,
      variables: dataStoreRepository.addGlobalVariable(variable),
    );
  }

  GlobalVariablesState delete(GlobalVariable variable) {
    if (_findVariableUUID(variable.uuid) != variable) {
      return copyWith(status: GlobalVariablesStatus.deleteFailedNotFound);
    }

    return copyWith(
      status: GlobalVariablesStatus.deleted,
      variables: dataStoreRepository.deleteGlobalVariable(variable),
    );
  }

  @override
  List<Object?> get props => [status, variables];

  GlobalVariable? getVariable(String uuid) {
    for (final variable in variables) {
      if (uuid == variable.uuid) {
        return variable;
      }
    }
    return null;
  }

  GlobalVariablesState changing() {
    return copyWith(status: GlobalVariablesStatus.changing);
  }

  GlobalVariablesState update(GlobalVariable newValue) {
    final existing = _findVariableUUID(newValue.uuid);
    if (existing != null) {
      final index = variables.indexOf(existing);

      return copyWith(
        status: GlobalVariablesStatus.updated,
        variables: List.from(variables)..replaceRange(index, index + 1, [newValue]),
      );
    }
    return copyWith(status: GlobalVariablesStatus.updateFailedUUIDNotFound);
  }
}
