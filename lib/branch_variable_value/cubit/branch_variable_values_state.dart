part of 'branch_variable_values_cubit.dart';

enum BranchVariableValuesStatus { initial, loaded, saved, added, addFailedUUIDExists, addFailedUUIDCombinationExists, deleted, deleteFailedNotFound, failure }

extension BranchVariableValuesStatusX on BranchVariableValuesStatus {
  bool get isInitial => this == BranchVariableValuesStatus.initial;
  bool get isSaved => this == BranchVariableValuesStatus.saved;
  bool get isLoaded => this == BranchVariableValuesStatus.loaded;
  bool get isAdded => this == BranchVariableValuesStatus.added;
  bool get isAddFailedUUIDExists => this == BranchVariableValuesStatus.addFailedUUIDExists;
  bool get isAddFailedUUIDCombinationExists => this == BranchVariableValuesStatus.addFailedUUIDCombinationExists;
  bool get isDeleted => this == BranchVariableValuesStatus.deleted;
  bool get isDeleteFailedNotFound => this == BranchVariableValuesStatus.deleteFailedNotFound;
  bool get isFailure => this == BranchVariableValuesStatus.failure;
}

class BranchVariableValuesState extends Equatable {
  BranchVariableValuesState({this.status = BranchVariableValuesStatus.initial, List<BranchVariableValue>? branchVariableValues}) : branchVariableValues = List.from(branchVariableValues ?? []);

  final List<BranchVariableValue> branchVariableValues;
  final BranchVariableValuesStatus status;

  BranchVariableValuesState copyWith({required BranchVariableValuesStatus status, List<BranchVariableValue>? branchVariableValues}) {
    return BranchVariableValuesState(
      status: status,
      branchVariableValues: List.from(branchVariableValues ?? this.branchVariableValues),
    );
  }

  BranchVariableValue? _findVariableUUID(String uuid) {
    for (final branchVariableValue in branchVariableValues) {
      if (uuid == branchVariableValue.uuid) {
        return branchVariableValue;
      }
    }
    return null;
  }

  BranchVariableValue? _findVariableUUIDCombination(String branchUuid, String variableUuid) {
    for (final branchVariableValue in branchVariableValues) {
      if (branchUuid == branchVariableValue.branchUuid && variableUuid == branchVariableValue.variableUuid) {
        return branchVariableValue;
      }
    }
    return null;
  }

  BranchVariableValuesState load(DataStoreRepository dataStoreRepository) {
    return copyWith(
      status: BranchVariableValuesStatus.loaded,
      branchVariableValues: List.from(dataStoreRepository.branchVariableValues, growable: true),
    );
  }

  BranchVariableValuesState save(DataStoreRepository dataStoreRepository) {
    dataStoreRepository.branchVariableValues = branchVariableValues;
    return copyWith(status: BranchVariableValuesStatus.saved);
  }

  BranchVariableValuesState add(BranchVariableValue branchVariableValue) {
    if (_findVariableUUID(branchVariableValue.uuid) != null) {
      return copyWith(status: BranchVariableValuesStatus.addFailedUUIDExists);
    }

    if (_findVariableUUIDCombination(branchVariableValue.branchUuid, branchVariableValue.variableUuid) != null) {
      return copyWith(status: BranchVariableValuesStatus.addFailedUUIDCombinationExists);
    }

    branchVariableValues.add(branchVariableValue);
    return copyWith(status: BranchVariableValuesStatus.added);
  }

  BranchVariableValuesState delete(BranchVariableValue branchVariableValue) {
    if (_findVariableUUID(branchVariableValue.uuid) != branchVariableValue) {
      return copyWith(status: BranchVariableValuesStatus.deleteFailedNotFound);
    }
    branchVariableValues.removeWhere((element) => element.uuid == branchVariableValue.uuid);
    return copyWith(status: BranchVariableValuesStatus.deleted);
  }

  @override
  List<Object?> get props => [status, branchVariableValues];

  BranchVariableValue? getBranchVariableValue(String uuid) {
    for (final branchVariableValue in branchVariableValues) {
      if (uuid == branchVariableValue.uuid) {
        return branchVariableValue;
      }
    }
    return null;
  }
}
