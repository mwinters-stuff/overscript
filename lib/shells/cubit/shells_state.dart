part of 'shells_cubit.dart';

enum ShellsStatus { initial, loaded, changing, saved, added, addFailedUUIDExists, addFailedNameExists, deleted, deleteFailedNotFound, failure, updateFailedUUIDNotFound, updated }

extension VariablesStatusX on ShellsStatus {
  bool get isInitial => this == ShellsStatus.initial;
  bool get isChanging => this == ShellsStatus.changing;
  bool get isSaved => this == ShellsStatus.saved;
  bool get isLoaded => this == ShellsStatus.loaded;
  bool get isAdded => this == ShellsStatus.added;
  bool get isAddFailedUUIDExists => this == ShellsStatus.addFailedUUIDExists;
  bool get isAddFailedNameExists => this == ShellsStatus.addFailedNameExists;
  bool get isDeleted => this == ShellsStatus.deleted;
  bool get isDeleteFailedNotFound => this == ShellsStatus.deleteFailedNotFound;
  bool get isFailure => this == ShellsStatus.failure;
  bool get isUpdateFailedUUIDNotFound => this == ShellsStatus.updateFailedUUIDNotFound;
  bool get isUpdated => this == ShellsStatus.updated;
}

class ShellsState extends Equatable {
  ShellsState({
    required this.dataStoreRepository,
    this.status = ShellsStatus.initial,
    List<Shell>? variables,
  }) {
    if (variables != null) {
      dataStoreRepository.shells = variables;
    }
  }

  final ShellsStatus status;
  final DataStoreRepository dataStoreRepository;

  List<Shell> get shells => dataStoreRepository.shells;

  ShellsState copyWith({required ShellsStatus status, List<Shell>? variables}) {
    return ShellsState(
      dataStoreRepository: dataStoreRepository,
      status: status,
      variables: variables ?? dataStoreRepository.shells,
    );
  }

  Shell? _findUUID(String uuid) {
    for (final variable in shells) {
      if (uuid == variable.uuid) {
        return variable;
      }
    }
    return null;
  }

  ShellsState load() {
    return copyWith(
      status: ShellsStatus.loaded,
      variables: List.from(dataStoreRepository.shells),
    );
  }

  ShellsState add(Shell shell) {
    if (_findUUID(shell.uuid) != null) {
      return copyWith(status: ShellsStatus.addFailedUUIDExists);
    }

    return copyWith(
      status: ShellsStatus.added,
      variables: dataStoreRepository.addShell(shell),
    );
  }

  ShellsState delete(Shell shell) {
    if (_findUUID(shell.uuid) != shell) {
      return copyWith(status: ShellsStatus.deleteFailedNotFound);
    }

    return copyWith(
      status: ShellsStatus.deleted,
      variables: dataStoreRepository.deleteShell(shell),
    );
  }

  @override
  List<Object?> get props => [status, shells];

  Shell? get(String uuid) {
    for (final shell in shells) {
      if (uuid == shell.uuid) {
        return shell;
      }
    }
    return null;
  }

  ShellsState changing() {
    return copyWith(status: ShellsStatus.changing);
  }

  ShellsState update(Shell newValue) {
    final existing = _findUUID(newValue.uuid);
    if (existing != null) {
      final index = shells.indexOf(existing);

      return copyWith(
        status: ShellsStatus.updated,
        variables: List.from(shells)..replaceRange(index, index + 1, [newValue]),
      );
    }
    return copyWith(status: ShellsStatus.updateFailedUUIDNotFound);
  }
}
