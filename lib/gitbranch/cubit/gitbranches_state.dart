part of 'gitbranches_cubit.dart';

enum GitBranchesStatus { initial, changing, loaded, saved, added, addFailedUUIDExists, addFailedNameExists, addFailedDirectoryExists, addFailedOriginMismatch, deleted, deleteFailedNotFound, failure }

extension GitBranchesStatusX on GitBranchesStatus {
  bool get isInitial => this == GitBranchesStatus.initial;
  bool get isChanging => this == GitBranchesStatus.changing;
  bool get isSaved => this == GitBranchesStatus.saved;
  bool get isLoaded => this == GitBranchesStatus.loaded;
  bool get isAdded => this == GitBranchesStatus.added;
  bool get isAddFailedUUIDExists => this == GitBranchesStatus.addFailedUUIDExists;
  bool get isAddFailedNameExists => this == GitBranchesStatus.addFailedNameExists;
  bool get isAddFailedDirectoryExists => this == GitBranchesStatus.addFailedDirectoryExists;
  bool get isAddOriginMismatch => this == GitBranchesStatus.addFailedOriginMismatch;
  bool get isDeleted => this == GitBranchesStatus.deleted;
  bool get isDeleteFailedNotFound => this == GitBranchesStatus.deleteFailedNotFound;
  bool get isFailure => this == GitBranchesStatus.failure;
}

class GitBranchesState extends Equatable {
  GitBranchesState({
    required this.dataStoreRepository,
    this.status = GitBranchesStatus.initial,
    List<GitBranch>? branches,
  }) {
    dataStoreRepository.branches = branches ?? [];
  }

  final GitBranchesStatus status;
  final DataStoreRepository dataStoreRepository;

  List<GitBranch> get branches => dataStoreRepository.branches;

  GitBranchesState copyWith({
    required GitBranchesStatus status,
    List<GitBranch>? branches,
  }) {
    return GitBranchesState(
      dataStoreRepository: dataStoreRepository,
      status: status,
      branches: branches ?? this.branches,
    );
  }

  GitBranch? _findBranchUUID(String uuid) {
    for (final branch in branches) {
      if (uuid == branch.uuid) {
        return branch;
      }
    }
    return null;
  }

  GitBranch? _findBranchDirectory(String directory) {
    for (final branch in branches) {
      if (directory == branch.directory) {
        return branch;
      }
    }
    return null;
  }

  GitBranch? _findBranchName(String name) {
    for (final branch in branches) {
      if (name == branch.name) {
        return branch;
      }
    }
    return null;
  }

  bool _checkOrigin(String origin) {
    if (branches.isNotEmpty) {
      return branches[0].origin == origin;
    }
    return true;
  }

  GitBranchesState load() {
    return copyWith(
      status: GitBranchesStatus.loaded,
      branches: List.from(dataStoreRepository.branches),
    );
  }

  GitBranchesState add(GitBranch branch) {
    if (_findBranchUUID(branch.uuid) != null) {
      return copyWith(status: GitBranchesStatus.addFailedUUIDExists);
    }

    if (_findBranchName(branch.name) != null) {
      return copyWith(status: GitBranchesStatus.addFailedNameExists);
    }

    if (_findBranchDirectory(branch.directory) != null) {
      return copyWith(status: GitBranchesStatus.addFailedDirectoryExists);
    }

    if (!_checkOrigin(branch.origin)) {
      return copyWith(status: GitBranchesStatus.addFailedOriginMismatch);
    }

    return copyWith(
      status: GitBranchesStatus.added,
      branches: dataStoreRepository.addBranch(branch),
    );
  }

  GitBranchesState delete(GitBranch branch) {
    if (_findBranchUUID(branch.uuid) != branch) {
      return copyWith(status: GitBranchesStatus.deleteFailedNotFound);
    }

    return copyWith(
      status: GitBranchesStatus.deleted,
      branches: dataStoreRepository.deleteBranch(branch),
    );
  }

  GitBranchesState changing() {
    return copyWith(status: GitBranchesStatus.changing);
  }

  @override
  List<Object?> get props => [status, branches];

  GitBranch? getBranch(String uuid) {
    for (final branch in branches) {
      if (uuid == branch.uuid) {
        return branch;
      }
    }
    return null;
  }
}
