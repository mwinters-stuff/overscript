import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/repositories/data_store_repository.dart';
import 'package:overscript/shells/shells.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShellsCubit', () {
    late DataStoreRepository dataStoreRepository;

    setUp(() {
      dataStoreRepository = DataStoreRepository(mockDataStoreRepositoryJsonFile());
    });

    test(
      'initial state is empty list',
      () {
        final cubit = ShellsCubit(dataStoreRepository: dataStoreRepository);
        expect(cubit.state, equals(ShellsState(dataStoreRepository: dataStoreRepository)));
        expect(cubit.state.shells, equals(<Shell>[]));
      },
    );

    blocTest<ShellsCubit, ShellsState>(
      'add success',
      build: () => ShellsCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.add(mockShell1),
      expect: () => [
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.added,
            variables: [mockShell1],
          ),
        )
      ],
    );

    blocTest<ShellsCubit, ShellsState>(
      'add two',
      build: () => ShellsCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) {
        cubit
          ..add(
            mockShell1,
          )
          ..add(
            mockShell2,
          );
      },
      expect: () => [
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.added,
            variables: [
              mockShell1,
            ],
          ),
        ),
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.changing,
            variables: [
              mockShell1,
            ],
          ),
        ),
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.added,
            variables: [
              mockShell1,
              mockShell2,
            ],
          ),
        ),
      ],
    );

    blocTest<ShellsCubit, ShellsState>(
      'add uuid already exists',
      build: () => ShellsCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          mockShell1,
        ),
      act: (cubit) => cubit.add(
        const Shell(
          uuid: 'sh-uuid-1',
          command: '/usr/bin/bash2',
          args: [
            '-c',
          ],
        ),
      ),
      expect: () => [
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.changing,
            variables: [mockShell1],
          ),
        ),
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.addFailedUUIDExists,
            variables: [mockShell1],
          ),
        )
      ],
    );

    blocTest<ShellsCubit, ShellsState>(
      'delete success',
      build: () => ShellsCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          mockShell1,
        ),
      act: (cubit) => cubit.delete(mockShell1),
      expect: () => [
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.changing,
            variables: [
              mockShell1,
            ],
          ),
        ),
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.deleted,
            variables: const [],
          ),
        )
      ],
    );

    blocTest<ShellsCubit, ShellsState>(
      'delete failed not found',
      build: () => ShellsCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          mockShell1,
        ),
      act: (cubit) => cubit.delete(mockShell2),
      expect: () => [
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.changing,
            variables: [
              mockShell1,
            ],
          ),
        ),
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.deleteFailedNotFound,
            variables: [
              mockShell1,
            ],
          ),
        )
      ],
    );

    blocTest<ShellsCubit, ShellsState>(
      'load from datastore',
      setUp: () {
        dataStoreRepository.load('a-file.json');
      },
      build: () => ShellsCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.load(),
      expect: () => [
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.loaded,
            variables: [mockShell1, mockShell2],
          ),
        ),
      ],
    );

    test('test get ', () {
      final cubit = ShellsCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          mockShell1,
        )
        ..add(
          mockShell2,
        );

      expect(cubit.get('unknown'), isNull);
      expect(
        cubit.get('sh-uuid-2'),
        equals(mockShell2),
      );
      expect(
        cubit.get('sh-uuid-1'),
        equals(
          mockShell1,
        ),
      );
    });

    blocTest<ShellsCubit, ShellsState>(
      'update args success',
      build: () => ShellsCubit(
        dataStoreRepository: dataStoreRepository,
      )..add(
          mockShell1,
        ),
      act: (cubit) => cubit.updateArgs(
        const Shell(
          uuid: 'sh-uuid-1',
          command: '/usr/bin/bash',
          args: [
            'new-arg1',
            'new-arg2',
          ],
        ),
      ),
      expect: () => [
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.changing,
            variables: [
              mockShell1,
            ],
          ),
        ),
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.updated,
            variables: const [
              Shell(
                uuid: 'sh-uuid-1',
                command: '/usr/bin/bash',
                args: [
                  'new-arg1',
                  'new-arg2',
                ],
              )
            ],
          ),
        )
      ],
    );

    blocTest<ShellsCubit, ShellsState>(
      'update failed uuid not found',
      build: () => ShellsCubit(
        dataStoreRepository: dataStoreRepository,
      )..add(
          mockShell1,
        ),
      act: (cubit) => cubit.updateArgs(
        const Shell(
          uuid: 'sh-uuid-10',
          command: '/usr/bin/bash',
          args: [
            'new-arg1',
            'new-arg2',
          ],
        ),
      ),
      expect: () => [
        ShellsState(
          dataStoreRepository: dataStoreRepository,
          status: ShellsStatus.changing,
          variables: [
            mockShell1,
          ],
        ),
        equals(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
            status: ShellsStatus.updateFailedUUIDNotFound,
            variables: [
              mockShell1,
            ],
          ),
        )
      ],
    );
    test('status test', () {
      var value = ShellsStatus.initial;
      expect(value.isInitial, isTrue);
      value = ShellsStatus.loaded;
      expect(value.isInitial, isFalse);
      expect(value.isLoaded, isTrue);

      value = ShellsStatus.saved;
      expect(value.isSaved, isTrue);
      value = ShellsStatus.changing;
      expect(value.isChanging, isTrue);
      value = ShellsStatus.added;
      expect(value.isAdded, isTrue);

      value = ShellsStatus.addFailedUUIDExists;
      expect(value.isAddFailedUUIDExists, isTrue);

      value = ShellsStatus.addFailedNameExists;
      expect(value.isAddFailedNameExists, isTrue);

      value = ShellsStatus.deleted;
      expect(value.isDeleted, isTrue);

      value = ShellsStatus.deleteFailedNotFound;
      expect(value.isDeleteFailedNotFound, isTrue);

      value = ShellsStatus.failure;
      expect(value.isFailure, isTrue);

      value = ShellsStatus.updated;
      expect(value.isUpdated, isTrue);

      value = ShellsStatus.updateFailedUUIDNotFound;
      expect(value.isUpdateFailedUUIDNotFound, isTrue);
    });
  });
}
