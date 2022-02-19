part of 'branch_variable_values_cubit.dart';

enum BranchVariableValuesStatus {
  initial,
  loaded,
  changing,
  saved,
  added,
  updated,
  addFailedUUIDExists,
  addFailedUUIDCombinationExists,
  deleted,
  deleteFailedNotFound,
  failure,
  updateFailedUUIDNotFound
}

extension BranchVariableValuesStatusX on BranchVariableValuesStatus {
  bool get isInitial => this == BranchVariableValuesStatus.initial;
  bool get isSaved => this == BranchVariableValuesStatus.saved;
  bool get isChanging => this == BranchVariableValuesStatus.changing;
  bool get isLoaded => this == BranchVariableValuesStatus.loaded;
  bool get isAdded => this == BranchVariableValuesStatus.added;
  bool get isUpdated => this == BranchVariableValuesStatus.updated;
  bool get isUpdateFailedUUIDNotFound => this == BranchVariableValuesStatus.updateFailedUUIDNotFound;
  bool get isAddFailedUUIDExists => this == BranchVariableValuesStatus.addFailedUUIDExists;
  bool get isAddFailedUUIDCombinationExists => this == BranchVariableValuesStatus.addFailedUUIDCombinationExists;
  bool get isDeleted => this == BranchVariableValuesStatus.deleted;
  bool get isDeleteFailedNotFound => this == BranchVariableValuesStatus.deleteFailedNotFound;
  bool get isFailure => this == BranchVariableValuesStatus.failure;
}

class BranchVariableValuesState extends Equatable {
  BranchVariableValuesState({
    required this.dataStoreRepository,
    this.status = BranchVariableValuesStatus.initial,
    List<BranchVariableValue>? branchVariableValues,
  }) {
    if (branchVariableValues != null) {
      dataStoreRepository.branchVariableValues = branchVariableValues;
    }
  }

  final BranchVariableValuesStatus status;
  final DataStoreRepository dataStoreRepository;
  List<BranchVariableValue> get branchVariableValues => dataStoreRepository.branchVariableValues;

  BranchVariableValuesState copyWith({
    required BranchVariableValuesStatus status,
    List<BranchVariableValue>? branchVariableValues,
  }) {
    return BranchVariableValuesState(
      dataStoreRepository: dataStoreRepository,
      status: status,
      branchVariableValues: branchVariableValues ?? dataStoreRepository.branchVariableValues,
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

  BranchVariableValuesState load() {
    return copyWith(
      status: BranchVariableValuesStatus.loaded,
      branchVariableValues: List.from(branchVariableValues),
    );
  }

  BranchVariableValuesState add(BranchVariableValue branchVariableValue) {
    if (_findVariableUUID(branchVariableValue.uuid) != null) {
      return copyWith(status: BranchVariableValuesStatus.addFailedUUIDExists);
    }

    if (_findVariableUUIDCombination(branchVariableValue.branchUuid, branchVariableValue.variableUuid) != null) {
      return copyWith(status: BranchVariableValuesStatus.addFailedUUIDCombinationExists);
    }

    return copyWith(
      status: BranchVariableValuesStatus.added,
      branchVariableValues: List.from(branchVariableValues)..add(branchVariableValue),
    );
  }

  BranchVariableValuesState delete(BranchVariableValue branchVariableValue) {
    if (_findVariableUUID(branchVariableValue.uuid) != branchVariableValue) {
      return copyWith(status: BranchVariableValuesStatus.deleteFailedNotFound);
    }

    return copyWith(
      status: BranchVariableValuesStatus.deleted,
      branchVariableValues: List.from(branchVariableValues)..removeWhere((element) => element.uuid == branchVariableValue.uuid),
    );
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

  BranchVariableValuesState update(BranchVariableValue newValue) {
    final existing = _findVariableUUID(newValue.uuid);
    if (existing != null) {
      final index = branchVariableValues.indexOf(existing);

      return copyWith(
        status: BranchVariableValuesStatus.updated,
        branchVariableValues: List.from(branchVariableValues)..replaceRange(index, index + 1, [newValue]),
      );
    }
    return copyWith(status: BranchVariableValuesStatus.updateFailedUUIDNotFound);
  }

  BranchVariableValuesState changing() {
    return copyWith(status: BranchVariableValuesStatus.changing);
  }

  List<BranchVariableValue> getVariableValues(String variableUuid) {
    final result = <BranchVariableValue>[];
    for (final branchVariableValue in branchVariableValues) {
      if (variableUuid == branchVariableValue.variableUuid) {
        result.add(branchVariableValue);
      }
    }
    return result;
  }

  List<BranchVariableValue> getBranchValues(String branchUuid) {
    final result = <BranchVariableValue>[];
    for (final branchVariableValue in branchVariableValues) {
      if (branchUuid == branchVariableValue.branchUuid) {
        result.add(branchVariableValue);
      }
    }
    return result;
  }
}
