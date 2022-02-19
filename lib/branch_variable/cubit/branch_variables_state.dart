part of 'branch_variables_cubit.dart';

enum BranchVariablesStatus { initial, loaded, changing, saved, added, addFailedUUIDExists, addFailedNameExists, deleted, deleteFailedNotFound, failure }

extension VariablesStatusX on BranchVariablesStatus {
  bool get isInitial => this == BranchVariablesStatus.initial;
  bool get isChanging => this == BranchVariablesStatus.changing;
  bool get isSaved => this == BranchVariablesStatus.saved;
  bool get isLoaded => this == BranchVariablesStatus.loaded;
  bool get isAdded => this == BranchVariablesStatus.added;
  bool get isAddFailedUUIDExists => this == BranchVariablesStatus.addFailedUUIDExists;
  bool get isAddFailedNameExists => this == BranchVariablesStatus.addFailedNameExists;
  bool get isDeleted => this == BranchVariablesStatus.deleted;
  bool get isDeleteFailedNotFound => this == BranchVariablesStatus.deleteFailedNotFound;
  bool get isFailure => this == BranchVariablesStatus.failure;
}

class BranchVariablesState extends Equatable {
  BranchVariablesState({
    required this.dataStoreRepository,
    this.status = BranchVariablesStatus.initial,
    List<BranchVariable>? variables,
  }) {
    if (variables != null) {
      dataStoreRepository.branchVariables = variables;
    }
  }

  final BranchVariablesStatus status;
  final DataStoreRepository dataStoreRepository;

  List<BranchVariable> get variables => dataStoreRepository.branchVariables;

  BranchVariablesState copyWith({required BranchVariablesStatus status, List<BranchVariable>? variables}) {
    return BranchVariablesState(
      dataStoreRepository: dataStoreRepository,
      status: status,
      variables: variables ?? dataStoreRepository.branchVariables,
    );
  }

  BranchVariable? _findVariableUUID(String uuid) {
    for (final variable in variables) {
      if (uuid == variable.uuid) {
        return variable;
      }
    }
    return null;
  }

  BranchVariable? _findVariableName(String name) {
    for (final variable in variables) {
      if (name == variable.name) {
        return variable;
      }
    }
    return null;
  }

  BranchVariablesState load() {
    return copyWith(
      status: BranchVariablesStatus.loaded,
      variables: List.from(dataStoreRepository.branchVariables),
    );
  }

  BranchVariablesState add(BranchVariable variable) {
    if (_findVariableUUID(variable.uuid) != null) {
      return copyWith(status: BranchVariablesStatus.addFailedUUIDExists);
    }

    if (_findVariableName(variable.name) != null) {
      return copyWith(status: BranchVariablesStatus.addFailedNameExists);
    }

    return copyWith(
      status: BranchVariablesStatus.added,
      variables: dataStoreRepository.addBranchVariable(variable),
    );
  }

  BranchVariablesState delete(BranchVariable variable) {
    if (_findVariableUUID(variable.uuid) != variable) {
      return copyWith(status: BranchVariablesStatus.deleteFailedNotFound);
    }

    return copyWith(
      status: BranchVariablesStatus.deleted,
      variables: dataStoreRepository.deleteBranchVariable(variable),
    );
  }

  @override
  List<Object?> get props => [status, variables];

  BranchVariable? getVariable(String uuid) {
    for (final variable in variables) {
      if (uuid == variable.uuid) {
        return variable;
      }
    }
    return null;
  }

  BranchVariablesState changing() {
    return copyWith(status: BranchVariablesStatus.changing);
  }
}
