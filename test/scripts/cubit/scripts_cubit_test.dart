import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/repositories/data_store_repository.dart';
import 'package:overscript/scripts/scripts.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ScriptsCubit', () {
    late DataStoreRepository dataStoreRepository;

    setUp(() {
      dataStoreRepository = DataStoreRepository(mockDataStoreRepositoryJsonFile());
      initMocks();
    });

    test(
      'initial state is empty list',
      () {
        final cubit = ScriptsCubit(dataStoreRepository: dataStoreRepository);
        expect(cubit.state, equals(ScriptsState(dataStoreRepository: dataStoreRepository)));
        expect(cubit.state.scripts, equals(<Script>[]));
      },
    );

    blocTest<ScriptsCubit, ScriptsState>(
      'add success',
      build: () => ScriptsCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.add(mockScript1),
      expect: () => [
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.added,
            variables: [mockScript1],
          ),
        )
      ],
    );

    blocTest<ScriptsCubit, ScriptsState>(
      'add two',
      build: () => ScriptsCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) {
        cubit
          ..add(
            mockScript1,
          )
          ..add(
            mockScript2,
          );
      },
      expect: () => [
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.added,
            variables: [
              mockScript1,
            ],
          ),
        ),
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.changing,
            variables: [
              mockScript1,
            ],
          ),
        ),
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.added,
            variables: [
              mockScript1,
              mockScript2,
            ],
          ),
        ),
      ],
    );

    blocTest<ScriptsCubit, ScriptsState>(
      'add uuid already exists',
      build: () => ScriptsCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          mockScript1,
        ),
      act: (cubit) => cubit.add(
        mockScript1a,
      ),
      expect: () => [
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.changing,
            variables: [mockScript1],
          ),
        ),
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.addFailedUUIDExists,
            variables: [mockScript1],
          ),
        )
      ],
    );

    blocTest<ScriptsCubit, ScriptsState>(
      'add name already exists',
      build: () => ScriptsCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          mockScript2,
        ),
      act: (cubit) => cubit.add(
        mockScript1a,
      ),
      expect: () => [
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.changing,
            variables: [mockScript2],
          ),
        ),
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.addFailedNameExists,
            variables: [mockScript2],
          ),
        )
      ],
    );

    blocTest<ScriptsCubit, ScriptsState>(
      'delete success',
      build: () => ScriptsCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          mockScript1,
        ),
      act: (cubit) => cubit.delete(mockScript1),
      expect: () => [
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.changing,
            variables: [
              mockScript1,
            ],
          ),
        ),
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.deleted,
            variables: const [],
          ),
        )
      ],
    );

    blocTest<ScriptsCubit, ScriptsState>(
      'delete failed not found',
      build: () => ScriptsCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          mockScript1,
        ),
      act: (cubit) => cubit.delete(mockScript2),
      expect: () => [
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.changing,
            variables: [
              mockScript1,
            ],
          ),
        ),
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.deleteFailedNotFound,
            variables: [
              mockScript1,
            ],
          ),
        )
      ],
    );

    blocTest<ScriptsCubit, ScriptsState>(
      'load from datastore',
      setUp: () {
        dataStoreRepository.load('a-file.json');
      },
      build: () => ScriptsCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.load(),
      expect: () => [
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.loaded,
            variables: [mockScript1, mockScript2],
          ),
        ),
      ],
    );

    test('test get ', () {
      final cubit = ScriptsCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          mockScript1,
        )
        ..add(
          mockScript2,
        );

      expect(cubit.get('unknown'), isNull);
      expect(
        cubit.get('s-uuid-2'),
        equals(mockScript2),
      );
      expect(
        cubit.get('s-uuid-1'),
        equals(
          mockScript1,
        ),
      );
    });

    blocTest<ScriptsCubit, ScriptsState>(
      'update args success',
      build: () => ScriptsCubit(
        dataStoreRepository: dataStoreRepository,
      )..add(
          mockScript1,
        ),
      act: (cubit) => cubit.update(mockScript1a),
      expect: () => [
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.changing,
            variables: [
              mockScript1,
            ],
          ),
        ),
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.updated,
            variables: [
              mockScript1a,
            ],
          ),
        )
      ],
    );

    blocTest<ScriptsCubit, ScriptsState>(
      'update failed uuid not found',
      build: () => ScriptsCubit(
        dataStoreRepository: dataStoreRepository,
      )..add(
          mockScript1,
        ),
      act: (cubit) => cubit.update(mockScript2),
      expect: () => [
        ScriptsState(
          dataStoreRepository: dataStoreRepository,
          status: ScriptsStatus.changing,
          variables: [
            mockScript1,
          ],
        ),
        equals(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
            status: ScriptsStatus.updateFailedUUIDNotFound,
            variables: [
              mockScript1,
            ],
          ),
        )
      ],
    );
    test('status test', () {
      var value = ScriptsStatus.initial;
      expect(value.isInitial, isTrue);
      value = ScriptsStatus.loaded;
      expect(value.isInitial, isFalse);
      expect(value.isLoaded, isTrue);

      value = ScriptsStatus.saved;
      expect(value.isSaved, isTrue);
      value = ScriptsStatus.changing;
      expect(value.isChanging, isTrue);
      value = ScriptsStatus.added;
      expect(value.isAdded, isTrue);

      value = ScriptsStatus.addFailedUUIDExists;
      expect(value.isAddFailedUUIDExists, isTrue);

      value = ScriptsStatus.addFailedNameExists;
      expect(value.isAddFailedNameExists, isTrue);

      value = ScriptsStatus.deleted;
      expect(value.isDeleted, isTrue);

      value = ScriptsStatus.deleteFailedNotFound;
      expect(value.isDeleteFailedNotFound, isTrue);

      value = ScriptsStatus.failure;
      expect(value.isFailure, isTrue);

      value = ScriptsStatus.updated;
      expect(value.isUpdated, isTrue);

      value = ScriptsStatus.updateFailedUUIDNotFound;
      expect(value.isUpdateFailedUUIDNotFound, isTrue);
    });
  });
}
