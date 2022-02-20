import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';
import 'package:overscript/repositories/data_store_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('GlobalEnvironmentVariablesCubit', () {
    late DataStoreRepository dataStoreRepository;

    setUp(() {
      dataStoreRepository = DataStoreRepository(mockDataStoreRepositoryJsonFile());
    });

    test(
      'initial state is empty list',
      () {
        final cubit = GlobalEnvironmentVariablesCubit(dataStoreRepository: dataStoreRepository);
        expect(cubit.state, equals(GlobalEnvironmentVariablesState(dataStoreRepository: dataStoreRepository)));
        expect(cubit.state.variables, equals(<GlobalEnvironmentVariable>[]));
      },
    );

    blocTest<GlobalEnvironmentVariablesCubit, GlobalEnvironmentVariablesState>(
      'add success',
      build: () => GlobalEnvironmentVariablesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.add(
        const GlobalEnvironmentVariable(
          uuid: 'a-uuid',
          name: 'variable-one',
          value: '/some/value',
        ),
      ),
      expect: () => [
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.added,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        )
      ],
    );

    blocTest<GlobalEnvironmentVariablesCubit, GlobalEnvironmentVariablesState>(
      'add two',
      build: () => GlobalEnvironmentVariablesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) {
        cubit
          ..add(
            const GlobalEnvironmentVariable(
              uuid: 'a-uuid',
              name: 'variable-one',
              value: '/some/value',
            ),
          )
          ..add(
            const GlobalEnvironmentVariable(
              uuid: 'a-uuid-2',
              name: 'variable-two',
              value: '/some/other/value',
            ),
          );
      },
      expect: () => [
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.added,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        ),
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.changing,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              ),
            ],
          ),
        ),
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.added,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              ),
              GlobalEnvironmentVariable(
                uuid: 'a-uuid-2',
                name: 'variable-two',
                value: '/some/other/value',
              )
            ],
          ),
        ),
      ],
    );

    blocTest<GlobalEnvironmentVariablesCubit, GlobalEnvironmentVariablesState>(
      'add uuid already exists',
      build: () => GlobalEnvironmentVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      act: (cubit) => cubit.add(
        const GlobalEnvironmentVariable(
          uuid: 'a-uuid',
          name: 'variable-two',
          value: '/some/other/value',
        ),
      ),
      expect: () => [
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.changing,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        ),
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.addFailedUUIDExists,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        )
      ],
    );

    blocTest<GlobalEnvironmentVariablesCubit, GlobalEnvironmentVariablesState>(
      'add name already exists',
      build: () => GlobalEnvironmentVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      act: (cubit) => cubit.add(
        const GlobalEnvironmentVariable(
          uuid: 'a-uuid-2',
          name: 'variable-one',
          value: '/some/other/value',
        ),
      ),
      expect: () => [
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.changing,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        ),
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.addFailedNameExists,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        )
      ],
    );

    blocTest<GlobalEnvironmentVariablesCubit, GlobalEnvironmentVariablesState>(
      'delete success',
      build: () => GlobalEnvironmentVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      act: (cubit) => cubit.delete(
        const GlobalEnvironmentVariable(
          uuid: 'a-uuid',
          name: 'variable-one',
          value: '/some/value',
        ),
      ),
      expect: () => [
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.changing,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              ),
            ],
          ),
        ),
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.deleted,
            variables: const [],
          ),
        )
      ],
    );

    blocTest<GlobalEnvironmentVariablesCubit, GlobalEnvironmentVariablesState>(
      'delete failed not found',
      build: () => GlobalEnvironmentVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      act: (cubit) => cubit.delete(
        const GlobalEnvironmentVariable(
          uuid: 'a-uuid-2',
          name: 'variable-one',
          value: '/some/value',
        ),
      ),
      expect: () => [
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.changing,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        ),
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.deleteFailedNotFound,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              ),
            ],
          ),
        )
      ],
    );

    blocTest<GlobalEnvironmentVariablesCubit, GlobalEnvironmentVariablesState>(
      'load from datastore',
      setUp: () {
        dataStoreRepository.load('a-file.json');
      },
      build: () => GlobalEnvironmentVariablesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.load(),
      expect: () => [
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.loaded,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'g-uuid-1',
                name: 'global-variable-1',
                value: '/global/variable/value/1',
              ),
              GlobalEnvironmentVariable(
                uuid: 'a-uuid-2',
                name: 'global-variable-2',
                value: '/global/variable/value/2',
              ),
            ],
          ),
        ),
      ],
    );

    test('test get variable', () {
      final cubit = GlobalEnvironmentVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        )
        ..add(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid-2',
            name: 'variable-two',
            value: '/some/other/value',
          ),
        );

      expect(cubit.getVariable('unknown'), isNull);
      expect(
        cubit.getVariable('a-uuid-2'),
        equals(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid-2',
            name: 'variable-two',
            value: '/some/other/value',
          ),
        ),
      );
      expect(
        cubit.getVariable('a-uuid'),
        equals(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      );
    });

    blocTest<GlobalEnvironmentVariablesCubit, GlobalEnvironmentVariablesState>(
      'update success',
      build: () => GlobalEnvironmentVariablesCubit(
        dataStoreRepository: dataStoreRepository,
      )..add(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      act: (cubit) => cubit.updateValue(
        const GlobalEnvironmentVariable(
          uuid: 'a-uuid',
          name: 'variable-one',
          value: 'updated value',
        ),
      ),
      expect: () => [
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.changing,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              ),
            ],
          ),
        ),
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.updated,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: 'updated value',
              )
            ],
          ),
        )
      ],
    );

    blocTest<GlobalEnvironmentVariablesCubit, GlobalEnvironmentVariablesState>(
      'update failed uuid not found',
      build: () => GlobalEnvironmentVariablesCubit(
        dataStoreRepository: dataStoreRepository,
      )..add(
          const GlobalEnvironmentVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      act: (cubit) => cubit.updateValue(
        const GlobalEnvironmentVariable(
          uuid: 'a-uuid-bad',
          name: 'variable-one',
          value: 'updated value',
        ),
      ),
      expect: () => [
        GlobalEnvironmentVariablesState(
          dataStoreRepository: dataStoreRepository,
          status: GlobalEnvironmentVariablesStatus.changing,
          variables: const [
            GlobalEnvironmentVariable(
              uuid: 'a-uuid',
              name: 'variable-one',
              value: '/some/value',
            ),
          ],
        ),
        equals(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalEnvironmentVariablesStatus.updateFailedUUIDNotFound,
            variables: const [
              GlobalEnvironmentVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              ),
            ],
          ),
        )
      ],
    );
    test('status test', () {
      var value = GlobalEnvironmentVariablesStatus.initial;
      expect(value.isInitial, isTrue);
      value = GlobalEnvironmentVariablesStatus.loaded;
      expect(value.isInitial, isFalse);
      expect(value.isLoaded, isTrue);

      value = GlobalEnvironmentVariablesStatus.saved;
      expect(value.isSaved, isTrue);
      value = GlobalEnvironmentVariablesStatus.changing;
      expect(value.isChanging, isTrue);
      value = GlobalEnvironmentVariablesStatus.added;
      expect(value.isAdded, isTrue);

      value = GlobalEnvironmentVariablesStatus.addFailedUUIDExists;
      expect(value.isAddFailedUUIDExists, isTrue);

      value = GlobalEnvironmentVariablesStatus.addFailedNameExists;
      expect(value.isAddFailedNameExists, isTrue);

      value = GlobalEnvironmentVariablesStatus.deleted;
      expect(value.isDeleted, isTrue);

      value = GlobalEnvironmentVariablesStatus.deleteFailedNotFound;
      expect(value.isDeleteFailedNotFound, isTrue);

      value = GlobalEnvironmentVariablesStatus.failure;
      expect(value.isFailure, isTrue);

      value = GlobalEnvironmentVariablesStatus.updated;
      expect(value.isUpdated, isTrue);

      value = GlobalEnvironmentVariablesStatus.updateFailedUUIDNotFound;
      expect(value.isUpdateFailedUUIDNotFound, isTrue);
    });
  });
}
