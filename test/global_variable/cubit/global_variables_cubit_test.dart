// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/global_variable/global_variable.dart';
import 'package:overscript/repositories/data_store_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('GlobalVariablesCubit', () {
    late DataStoreRepository dataStoreRepository;

    setUp(() {
      dataStoreRepository = DataStoreRepository(mockDataStoreRepositoryJsonFile());
    });

    test(
      'initial state is empty list',
      () {
        final cubit = GlobalVariablesCubit(dataStoreRepository: dataStoreRepository);
        expect(cubit.state, equals(GlobalVariablesState(dataStoreRepository: dataStoreRepository)));
        expect(cubit.state.variables, equals(<GlobalVariable>[]));
      },
    );

    blocTest<GlobalVariablesCubit, GlobalVariablesState>(
      'add success',
      build: () => GlobalVariablesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.add(
        const GlobalVariable(
          uuid: 'a-uuid',
          name: 'variable-one',
          value: '/some/value',
        ),
      ),
      expect: () => [
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.added,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        )
      ],
    );

    blocTest<GlobalVariablesCubit, GlobalVariablesState>(
      'add two',
      build: () => GlobalVariablesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) {
        cubit
          ..add(
            const GlobalVariable(
              uuid: 'a-uuid',
              name: 'variable-one',
              value: '/some/value',
            ),
          )
          ..add(
            const GlobalVariable(
              uuid: 'a-uuid-2',
              name: 'variable-two',
              value: '/some/other/value',
            ),
          );
      },
      expect: () => [
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.added,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        ),
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.changing,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              ),
            ],
          ),
        ),
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.added,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              ),
              GlobalVariable(
                uuid: 'a-uuid-2',
                name: 'variable-two',
                value: '/some/other/value',
              )
            ],
          ),
        ),
      ],
    );

    blocTest<GlobalVariablesCubit, GlobalVariablesState>(
      'add uuid already exists',
      build: () => GlobalVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GlobalVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      act: (cubit) => cubit.add(
        const GlobalVariable(
          uuid: 'a-uuid',
          name: 'variable-two',
          value: '/some/other/value',
        ),
      ),
      expect: () => [
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.changing,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        ),
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.addFailedUUIDExists,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        )
      ],
    );

    blocTest<GlobalVariablesCubit, GlobalVariablesState>(
      'add name already exists',
      build: () => GlobalVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GlobalVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      act: (cubit) => cubit.add(
        const GlobalVariable(
          uuid: 'a-uuid-2',
          name: 'variable-one',
          value: '/some/other/value',
        ),
      ),
      expect: () => [
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.changing,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        ),
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.addFailedNameExists,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        )
      ],
    );

    blocTest<GlobalVariablesCubit, GlobalVariablesState>(
      'delete success',
      build: () => GlobalVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GlobalVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      act: (cubit) => cubit.delete(
        const GlobalVariable(
          uuid: 'a-uuid',
          name: 'variable-one',
          value: '/some/value',
        ),
      ),
      expect: () => [
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.changing,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              ),
            ],
          ),
        ),
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.deleted,
            variables: const [],
          ),
        )
      ],
    );

    blocTest<GlobalVariablesCubit, GlobalVariablesState>(
      'delete failed not found',
      build: () => GlobalVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GlobalVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      act: (cubit) => cubit.delete(
        const GlobalVariable(
          uuid: 'a-uuid-2',
          name: 'variable-one',
          value: '/some/value',
        ),
      ),
      expect: () => [
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.changing,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              )
            ],
          ),
        ),
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.deleteFailedNotFound,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              ),
            ],
          ),
        )
      ],
    );

    blocTest<GlobalVariablesCubit, GlobalVariablesState>(
      'load from datastore',
      setUp: () {
        dataStoreRepository.load('a-file.json');
      },
      build: () => GlobalVariablesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.load(),
      expect: () => [
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.loaded,
            variables: const [
              GlobalVariable(
                uuid: 'g-uuid-1',
                name: 'global-variable-1',
                value: '/global/variable/value/1',
              ),
              GlobalVariable(
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
      final cubit = GlobalVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const GlobalVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        )
        ..add(
          const GlobalVariable(
            uuid: 'a-uuid-2',
            name: 'variable-two',
            value: '/some/other/value',
          ),
        );

      expect(cubit.getVariable('unknown'), isNull);
      expect(
        cubit.getVariable('a-uuid-2'),
        equals(
          const GlobalVariable(
            uuid: 'a-uuid-2',
            name: 'variable-two',
            value: '/some/other/value',
          ),
        ),
      );
      expect(
        cubit.getVariable('a-uuid'),
        equals(
          const GlobalVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      );
    });

    blocTest<GlobalVariablesCubit, GlobalVariablesState>(
      'update success',
      build: () => GlobalVariablesCubit(
        dataStoreRepository: dataStoreRepository,
      )..add(
          const GlobalVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      act: (cubit) => cubit.updateValue(
        const GlobalVariable(
          uuid: 'a-uuid',
          name: 'variable-one',
          value: 'updated value',
        ),
      ),
      expect: () => [
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.changing,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: '/some/value',
              ),
            ],
          ),
        ),
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.updated,
            variables: const [
              GlobalVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                value: 'updated value',
              )
            ],
          ),
        )
      ],
    );

    blocTest<GlobalVariablesCubit, GlobalVariablesState>(
      'update failed uuid not found',
      build: () => GlobalVariablesCubit(
        dataStoreRepository: dataStoreRepository,
      )..add(
          const GlobalVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            value: '/some/value',
          ),
        ),
      act: (cubit) => cubit.updateValue(
        const GlobalVariable(
          uuid: 'a-uuid-bad',
          name: 'variable-one',
          value: 'updated value',
        ),
      ),
      expect: () => [
        GlobalVariablesState(
          dataStoreRepository: dataStoreRepository,
          status: GlobalVariablesStatus.changing,
          variables: const [
            GlobalVariable(
              uuid: 'a-uuid',
              name: 'variable-one',
              value: '/some/value',
            ),
          ],
        ),
        equals(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: GlobalVariablesStatus.updateFailedUUIDNotFound,
            variables: const [
              GlobalVariable(
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
      var value = GlobalVariablesStatus.initial;
      expect(value.isInitial, isTrue);
      value = GlobalVariablesStatus.loaded;
      expect(value.isInitial, isFalse);
      expect(value.isLoaded, isTrue);

      value = GlobalVariablesStatus.saved;
      expect(value.isSaved, isTrue);
      value = GlobalVariablesStatus.changing;
      expect(value.isChanging, isTrue);
      value = GlobalVariablesStatus.added;
      expect(value.isAdded, isTrue);

      value = GlobalVariablesStatus.addFailedUUIDExists;
      expect(value.isAddFailedUUIDExists, isTrue);

      value = GlobalVariablesStatus.addFailedNameExists;
      expect(value.isAddFailedNameExists, isTrue);

      value = GlobalVariablesStatus.deleted;
      expect(value.isDeleted, isTrue);

      value = GlobalVariablesStatus.deleteFailedNotFound;
      expect(value.isDeleteFailedNotFound, isTrue);

      value = GlobalVariablesStatus.failure;
      expect(value.isFailure, isTrue);

      value = GlobalVariablesStatus.updated;
      expect(value.isUpdated, isTrue);

      value = GlobalVariablesStatus.updateFailedUUIDNotFound;
      expect(value.isUpdateFailedUUIDNotFound, isTrue);
    });
  });
}
