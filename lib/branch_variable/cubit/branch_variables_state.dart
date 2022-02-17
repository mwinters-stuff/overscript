part of 'branch_variables_cubit.dart';

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

class BranchVariablesState extends Equatable {
  BranchVariablesState({
    required this.dataStoreRepository,
    this.status = VariablesStatus.initial,
    List<BranchVariable>? variables,
  }) {
    dataStoreRepository.branchVariables = variables ?? [];
  }

  final VariablesStatus status;
  final DataStoreRepository dataStoreRepository;

  List<BranchVariable> get variables => dataStoreRepository.branchVariables;

  BranchVariablesState copyWith({required VariablesStatus status, List<BranchVariable>? variables}) {
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
      status: VariablesStatus.loaded,
      variables: List.from(dataStoreRepository.branchVariables),
    );
  }

  BranchVariablesState add(BranchVariable variable) {
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

  BranchVariablesState delete(BranchVariable variable) {
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

  BranchVariable? getVariable(String uuid) {
    for (final variable in variables) {
      if (uuid == variable.uuid) {
        return variable;
      }
    }
    return null;
  }

  BranchVariablesState changing() {
    return copyWith(status: VariablesStatus.changing);
  }
}
