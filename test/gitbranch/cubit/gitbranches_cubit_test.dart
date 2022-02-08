// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/gitbranch/cubit/gitbranch.dart';

import 'package:overscript/gitbranch/cubit/gitbranches_cubit.dart';
import 'package:overscript/repositories/data_store_repository.dart';

class MockDataStoreRepository extends Mock implements DataStoreRepository {}

void main() {
  group('GitBranchesCubit', () {
    late DataStoreRepository dataStoreRepository;

    setUp(() {
      dataStoreRepository = MockDataStoreRepository();
    });

    test(
      'initial state is empty list',
      () {
        final cubit = GitBranchesCubit();
        expect(cubit.state, equals(GitBranchesState()));
        expect(cubit.state.branches, equals(<GitBranch>[]));
      },
    );

    blocTest<GitBranchesCubit, GitBranchesState>(
      'add success no existing origin',
      build: () => GitBranchesCubit(),
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
            status: GitBranchesStatus.changing,
            branches: const [],
          ),
        ),
        equals(
          GitBranchesState(
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
      build: () => GitBranchesCubit()
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
      build: () => GitBranchesCubit()
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
      build: () => GitBranchesCubit()
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
      build: () => GitBranchesCubit()
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
      build: () => GitBranchesCubit()
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
      build: () => GitBranchesCubit()
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
            status: GitBranchesStatus.deleted,
            branches: const [],
          ),
        )
      ],
    );

    blocTest<GitBranchesCubit, GitBranchesState>(
      'delete failed not found',
      build: () => GitBranchesCubit()
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
        when(() => dataStoreRepository.branches).thenReturn(const [
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
        ]);
      },
      build: () => GitBranchesCubit(),
      act: (cubit) => cubit.load(dataStoreRepository),
      expect: () => [
        equals(
          GitBranchesState(
            status: GitBranchesStatus.changing,
            branches: const [],
          ),
        ),
        equals(
          GitBranchesState(
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

    blocTest<GitBranchesCubit, GitBranchesState>(
      'save to datastore',
      setUp: () {},
      build: () => GitBranchesCubit()
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
        ),
      act: (cubit) => cubit.save(dataStoreRepository),
      expect: () => [
        equals(
          GitBranchesState(
            status: GitBranchesStatus.saved,
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
      final cubit = GitBranchesCubit()
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
