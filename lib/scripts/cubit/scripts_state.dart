part of 'scripts_cubit.dart';

enum ScriptsStatus { initial, loaded, changing, saved, added, addFailedUUIDExists, addFailedNameExists, deleted, deleteFailedNotFound, failure, updateFailedUUIDNotFound, updated }

extension VariablesStatusX on ScriptsStatus {
  bool get isInitial => this == ScriptsStatus.initial;
  bool get isChanging => this == ScriptsStatus.changing;
  bool get isSaved => this == ScriptsStatus.saved;
  bool get isLoaded => this == ScriptsStatus.loaded;
  bool get isAdded => this == ScriptsStatus.added;
  bool get isAddFailedUUIDExists => this == ScriptsStatus.addFailedUUIDExists;
  bool get isAddFailedNameExists => this == ScriptsStatus.addFailedNameExists;
  bool get isDeleted => this == ScriptsStatus.deleted;
  bool get isDeleteFailedNotFound => this == ScriptsStatus.deleteFailedNotFound;
  bool get isFailure => this == ScriptsStatus.failure;
  bool get isUpdateFailedUUIDNotFound => this == ScriptsStatus.updateFailedUUIDNotFound;
  bool get isUpdated => this == ScriptsStatus.updated;
}

class ScriptsState extends Equatable {
  ScriptsState({
    required this.dataStoreRepository,
    this.status = ScriptsStatus.initial,
    List<Script>? variables,
  }) {
    if (variables != null) {
      dataStoreRepository.scripts = variables;
    }
  }

  final ScriptsStatus status;
  final DataStoreRepository dataStoreRepository;

  List<Script> get scripts => dataStoreRepository.scripts;

  ScriptsState copyWith({required ScriptsStatus status, List<Script>? variables}) {
    return ScriptsState(
      dataStoreRepository: dataStoreRepository,
      status: status,
      variables: variables ?? dataStoreRepository.scripts,
    );
  }

  Script? _findUUID(String uuid) {
    for (final variable in scripts) {
      if (uuid == variable.uuid) {
        return variable;
      }
    }
    return null;
  }

  Script? _findName(String name) {
    for (final variable in scripts) {
      if (name == variable.name) {
        return variable;
      }
    }
    return null;
  }

  ScriptsState load() {
    return copyWith(
      status: ScriptsStatus.loaded,
      variables: List.from(dataStoreRepository.scripts),
    );
  }

  ScriptsState add(Script script) {
    if (_findUUID(script.uuid) != null) {
      return copyWith(status: ScriptsStatus.addFailedUUIDExists);
    }

    if (_findName(script.name) != null) {
      return copyWith(status: ScriptsStatus.addFailedNameExists);
    }

    return copyWith(
      status: ScriptsStatus.added,
      variables: dataStoreRepository.addScript(script),
    );
  }

  ScriptsState delete(Script script) {
    if (_findUUID(script.uuid) != script) {
      return copyWith(status: ScriptsStatus.deleteFailedNotFound);
    }

    return copyWith(
      status: ScriptsStatus.deleted,
      variables: dataStoreRepository.deleteScript(script),
    );
  }

  @override
  List<Object?> get props => [status, scripts];

  Script? get(String uuid) {
    for (final script in scripts) {
      if (uuid == script.uuid) {
        return script;
      }
    }
    return null;
  }

  ScriptsState changing() {
    return copyWith(status: ScriptsStatus.changing);
  }

  ScriptsState update(Script newValue) {
    final existing = _findUUID(newValue.uuid);
    if (existing != null) {
      final index = scripts.indexOf(existing);

      return copyWith(
        status: ScriptsStatus.updated,
        variables: List.from(scripts)..replaceRange(index, index + 1, [newValue]),
      );
    }
    return copyWith(status: ScriptsStatus.updateFailedUUIDNotFound);
  }
}
