// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/repositories/data_store_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('BranchVariablesCubit', () {
    late DataStoreRepository dataStoreRepository;

    setUp(() {
      dataStoreRepository = DataStoreRepository(mockDataStoreRepositoryJsonFile());
    });

    test(
      'initial state is empty list',
      () {
        final cubit = BranchVariablesCubit(dataStoreRepository: dataStoreRepository);
        expect(cubit.state, equals(BranchVariablesState(dataStoreRepository: dataStoreRepository)));
        expect(cubit.state.variables, equals(<BranchVariable>[]));
      },
    );

    blocTest<BranchVariablesCubit, BranchVariablesState>(
      'add success',
      build: () => BranchVariablesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.add(
        const BranchVariable(
          uuid: 'a-uuid',
          name: 'variable-one',
          defaultValue: '/some/defaultValue',
        ),
      ),
      expect: () => [
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.added,
            variables: const [
              BranchVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              )
            ],
          ),
        )
      ],
    );

    blocTest<BranchVariablesCubit, BranchVariablesState>(
      'add two',
      build: () => BranchVariablesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) {
        cubit
          ..add(
            const BranchVariable(
              uuid: 'a-uuid',
              name: 'variable-one',
              defaultValue: '/some/defaultValue',
            ),
          )
          ..add(
            const BranchVariable(
              uuid: 'a-uuid-2',
              name: 'variable-two',
              defaultValue: '/some/other/defaultValue',
            ),
          );
      },
      expect: () => [
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.added,
            variables: const [
              BranchVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              )
            ],
          ),
        ),
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.changing,
            variables: const [
              BranchVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              ),
            ],
          ),
        ),
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.added,
            variables: const [
              BranchVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              ),
              BranchVariable(
                uuid: 'a-uuid-2',
                name: 'variable-two',
                defaultValue: '/some/other/defaultValue',
              )
            ],
          ),
        ),
      ],
    );

    blocTest<BranchVariablesCubit, BranchVariablesState>(
      'add uuid already exists',
      build: () => BranchVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        ),
      act: (cubit) => cubit.add(
        const BranchVariable(
          uuid: 'a-uuid',
          name: 'variable-two',
          defaultValue: '/some/other/defaultValue',
        ),
      ),
      expect: () => [
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.changing,
            variables: const [
              BranchVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              )
            ],
          ),
        ),
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.addFailedUUIDExists,
            variables: const [
              BranchVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              )
            ],
          ),
        )
      ],
    );

    blocTest<BranchVariablesCubit, BranchVariablesState>(
      'add name already exists',
      build: () => BranchVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        ),
      act: (cubit) => cubit.add(
        const BranchVariable(
          uuid: 'a-uuid-2',
          name: 'variable-one',
          defaultValue: '/some/other/defaultValue',
        ),
      ),
      expect: () => [
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.changing,
            variables: const [
              BranchVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              )
            ],
          ),
        ),
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.addFailedNameExists,
            variables: const [
              BranchVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              )
            ],
          ),
        )
      ],
    );

    blocTest<BranchVariablesCubit, BranchVariablesState>(
      'delete success',
      build: () => BranchVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        ),
      act: (cubit) => cubit.delete(
        const BranchVariable(
          uuid: 'a-uuid',
          name: 'variable-one',
          defaultValue: '/some/defaultValue',
        ),
      ),
      expect: () => [
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.changing,
            variables: const [
              BranchVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              ),
            ],
          ),
        ),
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.deleted,
            variables: const [],
          ),
        )
      ],
    );

    blocTest<BranchVariablesCubit, BranchVariablesState>(
      'delete failed not found',
      build: () => BranchVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        ),
      act: (cubit) => cubit.delete(
        const BranchVariable(
          uuid: 'a-uuid-2',
          name: 'variable-one',
          defaultValue: '/some/defaultValue',
        ),
      ),
      expect: () => [
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.changing,
            variables: const [
              BranchVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              )
            ],
          ),
        ),
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.deleteFailedNotFound,
            variables: const [
              BranchVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              ),
            ],
          ),
        )
      ],
    );

    blocTest<BranchVariablesCubit, BranchVariablesState>(
      'load from datastore',
      setUp: () {
        dataStoreRepository.load('a-file.json');
      },
      build: () => BranchVariablesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.load(),
      expect: () => [
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.changing,
            variables: const [],
          ),
        ),
        equals(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariablesStatus.loaded,
            variables: const [
              BranchVariable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              ),
              BranchVariable(
                uuid: 'a-uuid-2',
                name: 'variable-two',
                defaultValue: '/some/other/defaultValue',
              ),
            ],
          ),
        ),
      ],
    );

    test('test get variable', () {
      final cubit = BranchVariablesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        )
        ..add(
          const BranchVariable(
            uuid: 'a-uuid-2',
            name: 'variable-two',
            defaultValue: '/some/other/defaultValue',
          ),
        );

      expect(cubit.getVariable('unknown'), isNull);
      expect(
        cubit.getVariable('a-uuid-2'),
        equals(
          const BranchVariable(
            uuid: 'a-uuid-2',
            name: 'variable-two',
            defaultValue: '/some/other/defaultValue',
          ),
        ),
      );
      expect(
        cubit.getVariable('a-uuid'),
        equals(
          const BranchVariable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        ),
      );
    });

    test('x test', () {
      var value = BranchVariablesStatus.initial;
      expect(value.isInitial, isTrue);
      value = BranchVariablesStatus.loaded;
      expect(value.isInitial, isFalse);
      expect(value.isLoaded, isTrue);

      value = BranchVariablesStatus.saved;
      expect(value.isSaved, isTrue);
      value = BranchVariablesStatus.changing;
      expect(value.isChanging, isTrue);
      value = BranchVariablesStatus.added;
      expect(value.isAdded, isTrue);

      value = BranchVariablesStatus.addFailedUUIDExists;
      expect(value.isAddFailedUUIDExists, isTrue);

      value = BranchVariablesStatus.addFailedNameExists;
      expect(value.isAddFailedNameExists, isTrue);

      value = BranchVariablesStatus.deleted;
      expect(value.isDeleted, isTrue);

      value = BranchVariablesStatus.deleteFailedNotFound;
      expect(value.isDeleteFailedNotFound, isTrue);

      value = BranchVariablesStatus.failure;
      expect(value.isFailure, isTrue);
    });
  });
}
