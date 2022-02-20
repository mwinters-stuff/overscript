// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/repositories/data_store_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('GitBranchesCubit', () {
    late DataStoreRepository dataStoreRepository;

    setUp(() {
      dataStoreRepository = DataStoreRepository(mockDataStoreRepositoryJsonFile());
    });

    test(
      'initial state is empty list',
      () {
        final cubit = GitBranchesCubit(dataStoreRepository: dataStoreRepository);
        expect(cubit.state, equals(GitBranchesState(dataStoreRepository: dataStoreRepository)));
        expect(cubit.state.branches, equals(<GitBranch>[]));
      },
    );

    blocTest<GitBranchesCubit, GitBranchesState>(
      'add success no existing origin',
      build: () => GitBranchesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.add(
        const GitBranch(
          uuid: 'a-uuid',
          name: 'branch-one',
          directory: '/some/directory',
          origin: 'theorigin',
        ),
      ),
      expect: () => [
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.changing,
            branches: const [],
          ),
        ),
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.added,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              )
            ],
          ),
        )
      ],
    );

    blocTest<GitBranchesCubit, GitBranchesState>(
      'add success existing origin matches',
      build: () => GitBranchesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GitBranch(
            uuid: 'a-uuid',
            name: 'branch-one',
            directory: '/some/directory',
            origin: 'theorigin',
          ),
        ),
      act: (cubit) {
        cubit.add(
          const GitBranch(
            uuid: 'a-uuid-2',
            name: 'branch-two',
            directory: '/some/other/directory',
            origin: 'theorigin',
          ),
        );
      },
      expect: () => [
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.changing,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              )
            ],
          ),
        ),
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.added,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              ),
              GitBranch(
                uuid: 'a-uuid-2',
                name: 'branch-two',
                directory: '/some/other/directory',
                origin: 'theorigin',
              )
            ],
          ),
        ),
      ],
    );

    blocTest<GitBranchesCubit, GitBranchesState>(
      'add uuid already exists',
      build: () => GitBranchesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GitBranch(
            uuid: 'a-uuid',
            name: 'branch-one',
            directory: '/some/directory',
            origin: 'theorigin',
          ),
        ),
      act: (cubit) => cubit.add(
        const GitBranch(
          uuid: 'a-uuid',
          name: 'branch-two',
          directory: '/some/other/directory',
          origin: 'theorigin',
        ),
      ),
      expect: () => [
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.changing,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              )
            ],
          ),
        ),
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.addFailedUUIDExists,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              )
            ],
          ),
        )
      ],
    );

    blocTest<GitBranchesCubit, GitBranchesState>(
      'add name already exists',
      build: () => GitBranchesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GitBranch(
            uuid: 'a-uuid',
            name: 'branch-one',
            directory: '/some/directory',
            origin: 'theorigin',
          ),
        ),
      act: (cubit) => cubit.add(
        const GitBranch(
          uuid: 'a-uuid-2',
          name: 'branch-one',
          directory: '/some/other/directory',
          origin: 'theorigin',
        ),
      ),
      expect: () => [
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.changing,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              )
            ],
          ),
        ),
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.addFailedNameExists,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              )
            ],
          ),
        )
      ],
    );

    blocTest<GitBranchesCubit, GitBranchesState>(
      'add directory already exists',
      build: () => GitBranchesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GitBranch(
            uuid: 'a-uuid',
            name: 'branch-one',
            directory: '/some/directory',
            origin: 'theorigin',
          ),
        ),
      act: (cubit) => cubit.add(
        const GitBranch(
          uuid: 'a-uuid-2',
          name: 'branch-two',
          directory: '/some/directory',
          origin: 'theorigin',
        ),
      ),
      expect: () => [
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.changing,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              )
            ],
          ),
        ),
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.addFailedDirectoryExists,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              )
            ],
          ),
        )
      ],
    );

    blocTest<GitBranchesCubit, GitBranchesState>(
      'add origin mismatch',
      build: () => GitBranchesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GitBranch(
            uuid: 'a-uuid',
            name: 'branch-one',
            directory: '/some/directory',
            origin: 'theorigin',
          ),
        ),
      act: (cubit) => cubit.add(
        const GitBranch(
          uuid: 'a-uuid-2',
          name: 'branch-two',
          directory: '/some/other/directory',
          origin: 'thewrongorigin',
        ),
      ),
      expect: () => [
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.changing,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              )
            ],
          ),
        ),
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.addFailedOriginMismatch,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              ),
            ],
          ),
        ),
      ],
    );

    blocTest<GitBranchesCubit, GitBranchesState>(
      'delete success',
      build: () => GitBranchesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GitBranch(
            uuid: 'a-uuid',
            name: 'branch-one',
            directory: '/some/directory',
            origin: 'theorigin',
          ),
        ),
      act: (cubit) => cubit.delete(
        const GitBranch(
          uuid: 'a-uuid',
          name: 'branch-one',
          directory: '/some/directory',
          origin: 'theorigin',
        ),
      ),
      expect: () => [
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.changing,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              ),
            ],
          ),
        ),
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.deleted,
            branches: const [],
          ),
        )
      ],
    );

    blocTest<GitBranchesCubit, GitBranchesState>(
      'delete failed not found',
      build: () => GitBranchesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GitBranch(
            uuid: 'a-uuid',
            name: 'branch-one',
            directory: '/some/directory',
            origin: 'theorigin',
          ),
        ),
      act: (cubit) => cubit.delete(
        const GitBranch(
          uuid: 'a-uuid-2',
          name: 'branch-one',
          directory: '/some/directory',
          origin: 'theorigin',
        ),
      ),
      expect: () => [
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.changing,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              )
            ],
          ),
        ),
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.deleteFailedNotFound,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              ),
            ],
          ),
        )
      ],
    );

    blocTest<GitBranchesCubit, GitBranchesState>(
      'load from datastore',
      setUp: () {
        dataStoreRepository.load('a-file.json');
      },
      build: () => GitBranchesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.load(),
      expect: () => [
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.changing,
            branches: const [],
          ),
        ),
        equals(
          GitBranchesState(
            dataStoreRepository: dataStoreRepository,
            status: GitBranchesStatus.loaded,
            branches: const [
              GitBranch(
                uuid: 'a-uuid',
                name: 'branch-one',
                directory: '/some/directory',
                origin: 'theorigin',
              ),
              GitBranch(
                uuid: 'a-uuid-2',
                name: 'branch-two',
                directory: '/some/other/directory',
                origin: 'theorigin',
              ),
            ],
          ),
        ),
      ],
    );

    test('test get branch', () {
      final cubit = GitBranchesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GitBranch(
            uuid: 'a-uuid',
            name: 'branch-one',
            directory: '/some/directory',
            origin: 'theorigin',
          ),
        )
        ..add(
          const GitBranch(
            uuid: 'a-uuid-2',
            name: 'branch-two',
            directory: '/some/other/directory',
            origin: 'theorigin',
          ),
        );

      expect(cubit.getBranch('unknown'), isNull);
      expect(
        cubit.getBranch('a-uuid-2'),
        equals(
          const GitBranch(
            uuid: 'a-uuid-2',
            name: 'branch-two',
            directory: '/some/other/directory',
            origin: 'theorigin',
          ),
        ),
      );
      expect(
        cubit.getBranch('a-uuid'),
        equals(
          const GitBranch(
            uuid: 'a-uuid',
            name: 'branch-one',
            directory: '/some/directory',
            origin: 'theorigin',
          ),
        ),
      );
    });

    test('x test', () {
      var value = GitBranchesStatus.initial;
      expect(value.isInitial, isTrue);
      value = GitBranchesStatus.loaded;
      expect(value.isInitial, isFalse);
      expect(value.isLoaded, isTrue);

      value = GitBranchesStatus.saved;
      expect(value.isSaved, isTrue);

      value = GitBranchesStatus.added;
      expect(value.isAdded, isTrue);

      value = GitBranchesStatus.addFailedUUIDExists;
      expect(value.isAddFailedUUIDExists, isTrue);

      value = GitBranchesStatus.changing;
      expect(value.isChanging, isTrue);

      value = GitBranchesStatus.addFailedNameExists;
      expect(value.isAddFailedNameExists, isTrue);

      value = GitBranchesStatus.addFailedDirectoryExists;
      expect(value.isAddFailedDirectoryExists, isTrue);

      value = GitBranchesStatus.addFailedOriginMismatch;
      expect(value.isAddOriginMismatch, isTrue);

      value = GitBranchesStatus.deleted;
      expect(value.isDeleted, isTrue);

      value = GitBranchesStatus.deleteFailedNotFound;
      expect(value.isDeleteFailedNotFound, isTrue);

      value = GitBranchesStatus.failure;
      expect(value.isFailure, isTrue);
    });
  });
}
