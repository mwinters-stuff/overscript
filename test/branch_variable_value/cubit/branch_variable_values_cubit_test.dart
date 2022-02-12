// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/repositories/data_store_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('BranchVariableValuesCubit', () {
    late DataStoreRepository dataStoreRepository;

    setUp(() {
      dataStoreRepository = DataStoreRepository(mockDataStoreRepositoryJsonFile());
    });

    test(
      'initial state is empty list',
      () {
        final cubit = BranchVariableValuesCubit(dataStoreRepository: dataStoreRepository);
        expect(cubit.state, equals(BranchVariableValuesState(dataStoreRepository: dataStoreRepository)));
        expect(cubit.state.branchVariableValues, equals(<BranchVariableValue>[]));
      },
    );

    test('state getVariableValues', () {
      final cubit = BranchVariableValuesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariableValue(
            uuid: 'uuid1',
            branchUuid: 'branch-uuid',
            variableUuid: 'variable1-uuid',
            value: 'value',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'uuid2',
            branchUuid: 'branch-uuid-2',
            variableUuid: 'variable1-uuid',
            value: 'value',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'uuid3',
            branchUuid: 'branch-uuid',
            variableUuid: 'variable2-uuid',
            value: 'value2',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'uuid4',
            branchUuid: 'branch-uuid-2',
            variableUuid: 'variable2-uuid',
            value: 'value2',
          ),
        );

      expect(
        cubit.state.getVariableValues('variable2-uuid'),
        equals(
          [
            const BranchVariableValue(
              uuid: 'uuid3',
              branchUuid: 'branch-uuid',
              variableUuid: 'variable2-uuid',
              value: 'value2',
            ),
            const BranchVariableValue(
              uuid: 'uuid4',
              branchUuid: 'branch-uuid-2',
              variableUuid: 'variable2-uuid',
              value: 'value2',
            ),
          ],
        ),
      );

      expect(
        cubit.state.getVariableValues('variable1-uuid'),
        equals(
          [
            const BranchVariableValue(
              uuid: 'uuid1',
              branchUuid: 'branch-uuid',
              variableUuid: 'variable1-uuid',
              value: 'value',
            ),
            const BranchVariableValue(
              uuid: 'uuid2',
              branchUuid: 'branch-uuid-2',
              variableUuid: 'variable1-uuid',
              value: 'value',
            ),
          ],
        ),
      );
      expect(cubit.state.getVariableValues('variable3-uuid'), equals([]));
    });

    test('getVariableListItems', () {
      final cubit = BranchVariableValuesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariableValue(
            uuid: 'uuid1',
            branchUuid: 'branch-uuid',
            variableUuid: 'variable1-uuid',
            value: 'value',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'uuid2',
            branchUuid: 'branch-uuid-2',
            variableUuid: 'variable1-uuid',
            value: 'value',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'uuid3',
            branchUuid: 'branch-uuid',
            variableUuid: 'variable2-uuid',
            value: 'value2',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'uuid4',
            branchUuid: 'branch-uuid-2',
            variableUuid: 'variable2-uuid',
            value: 'value2',
          ),
        );

      final items = cubit.getVariableListItems('variable2-uuid');
      expect(items.length, equals(2));
      expect(
        items[0].branchVariableValue,
        equals(
          const BranchVariableValue(
            uuid: 'uuid3',
            branchUuid: 'branch-uuid',
            variableUuid: 'variable2-uuid',
            value: 'value2',
          ),
        ),
      );
      expect(
        items[1].branchVariableValue,
        equals(
          const BranchVariableValue(
            uuid: 'uuid4',
            branchUuid: 'branch-uuid-2',
            variableUuid: 'variable2-uuid',
            value: 'value2',
          ),
        ),
      );
    });

    test('state getBranchValues', () {
      final cubit = BranchVariableValuesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariableValue(
            uuid: 'uuid1',
            branchUuid: 'branch-uuid-1',
            variableUuid: 'variable1-uuid',
            value: 'value',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'uuid2',
            branchUuid: 'branch-uuid-2',
            variableUuid: 'variable1-uuid',
            value: 'value',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'uuid3',
            branchUuid: 'branch-uuid-1',
            variableUuid: 'variable2-uuid',
            value: 'value2',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'uuid4',
            branchUuid: 'branch-uuid-2',
            variableUuid: 'variable2-uuid',
            value: 'value2',
          ),
        );

      expect(
        cubit.state.getBranchValues('branch-uuid-1'),
        equals(
          [
            const BranchVariableValue(
              uuid: 'uuid1',
              branchUuid: 'branch-uuid-1',
              variableUuid: 'variable1-uuid',
              value: 'value',
            ),
            const BranchVariableValue(
              uuid: 'uuid3',
              branchUuid: 'branch-uuid-1',
              variableUuid: 'variable2-uuid',
              value: 'value2',
            ),
          ],
        ),
      );

      expect(
        cubit.state.getBranchValues('branch-uuid-2'),
        equals(
          [
            const BranchVariableValue(
              uuid: 'uuid2',
              branchUuid: 'branch-uuid-2',
              variableUuid: 'variable1-uuid',
              value: 'value',
            ),
            const BranchVariableValue(
              uuid: 'uuid4',
              branchUuid: 'branch-uuid-2',
              variableUuid: 'variable2-uuid',
              value: 'value2',
            ),
          ],
        ),
      );
      expect(cubit.state.getBranchValues('branch-uuid-3'), equals([]));
    });

    test('getBranchListItems', () {
      final cubit = BranchVariableValuesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariableValue(
            uuid: 'uuid1',
            branchUuid: 'branch-uuid-1',
            variableUuid: 'variable1-uuid',
            value: 'value',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'uuid2',
            branchUuid: 'branch-uuid-2',
            variableUuid: 'variable1-uuid',
            value: 'value',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'uuid3',
            branchUuid: 'branch-uuid-1',
            variableUuid: 'variable2-uuid',
            value: 'value2',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'uuid4',
            branchUuid: 'branch-uuid-2',
            variableUuid: 'variable2-uuid',
            value: 'value2',
          ),
        );
      final list = cubit.getBranchListItems('branch-uuid-1');
      expect(list.length, equals(2));

      expect(
        list[0].branchVariableValue,
        equals(
          const BranchVariableValue(
            uuid: 'uuid1',
            branchUuid: 'branch-uuid-1',
            variableUuid: 'variable1-uuid',
            value: 'value',
          ),
        ),
      );
      expect(
        list[1].branchVariableValue,
        equals(
          const BranchVariableValue(
            uuid: 'uuid3',
            branchUuid: 'branch-uuid-1',
            variableUuid: 'variable2-uuid',
            value: 'value2',
          ),
        ),
      );
    });

    blocTest<BranchVariableValuesCubit, BranchVariableValuesState>(
      'add success',
      build: () => BranchVariableValuesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) => cubit.add(
        const BranchVariableValue(
          uuid: 'uuid',
          branchUuid: 'branch-uuid',
          variableUuid: 'variable-uuid',
          value: 'value',
        ),
      ),
      expect: () => [
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.changing,
            branchVariableValues: const [],
          ),
        ),
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.added,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'uuid',
                branchUuid: 'branch-uuid',
                variableUuid: 'variable-uuid',
                value: 'value',
              )
            ],
          ),
        )
      ],
    );

    blocTest<BranchVariableValuesCubit, BranchVariableValuesState>(
      'add two',
      build: () => BranchVariableValuesCubit(dataStoreRepository: dataStoreRepository),
      act: (cubit) {
        cubit
          ..add(
            const BranchVariableValue(
              uuid: 'uuid',
              branchUuid: 'branch-uuid',
              variableUuid: 'variable-uuid',
              value: 'value',
            ),
          )
          ..add(
            const BranchVariableValue(
              uuid: 'uuid2',
              branchUuid: 'branch-uuid-2',
              variableUuid: 'variable-uuid',
              value: 'value',
            ),
          );
      },
      expect: () => [
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.changing,
            branchVariableValues: const [],
          ),
        ),
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.added,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'uuid',
                branchUuid: 'branch-uuid',
                variableUuid: 'variable-uuid',
                value: 'value',
              ),
            ],
          ),
        ),
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.changing,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'uuid',
                branchUuid: 'branch-uuid',
                variableUuid: 'variable-uuid',
                value: 'value',
              ),
            ],
          ),
        ),
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.added,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'uuid',
                branchUuid: 'branch-uuid',
                variableUuid: 'variable-uuid',
                value: 'value',
              ),
              BranchVariableValue(
                uuid: 'uuid2',
                branchUuid: 'branch-uuid-2',
                variableUuid: 'variable-uuid',
                value: 'value',
              )
            ],
          ),
        ),
      ],
    );

    blocTest<BranchVariableValuesCubit, BranchVariableValuesState>(
      'add uuid already exists',
      build: () => BranchVariableValuesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariableValue(
            uuid: 'uuid',
            branchUuid: 'branch-uuid',
            variableUuid: 'variable-uuid',
            value: 'value',
          ),
        ),
      act: (cubit) => cubit.add(
        const BranchVariableValue(
          uuid: 'uuid',
          branchUuid: 'branch-uuid-2',
          variableUuid: 'variable-uuid-1',
          value: 'value',
        ),
      ),
      expect: () => [
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.changing,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'uuid',
                branchUuid: 'branch-uuid',
                variableUuid: 'variable-uuid',
                value: 'value',
              )
            ],
          ),
        ),
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.addFailedUUIDExists,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'uuid',
                branchUuid: 'branch-uuid',
                variableUuid: 'variable-uuid',
                value: 'value',
              )
            ],
          ),
        )
      ],
    );

    blocTest<BranchVariableValuesCubit, BranchVariableValuesState>(
      'add uuid combination exists',
      build: () => BranchVariableValuesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariableValue(
            uuid: 'a-uuid',
            branchUuid: 'branch-uuid',
            variableUuid: 'variable-uuid',
            value: 'value',
          ),
        ),
      act: (cubit) => cubit.add(
        const BranchVariableValue(
          uuid: 'a-uuid-2',
          branchUuid: 'branch-uuid',
          variableUuid: 'variable-uuid',
          value: 'value',
        ),
      ),
      expect: () => [
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.changing,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'a-uuid',
                branchUuid: 'branch-uuid',
                variableUuid: 'variable-uuid',
                value: 'value',
              )
            ],
          ),
        ),
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.addFailedUUIDCombinationExists,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'a-uuid',
                branchUuid: 'branch-uuid',
                variableUuid: 'variable-uuid',
                value: 'value',
              )
            ],
          ),
        )
      ],
    );

    blocTest<BranchVariableValuesCubit, BranchVariableValuesState>(
      'delete success',
      build: () => BranchVariableValuesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariableValue(
            uuid: 'a-uuid',
            branchUuid: 'branch-uuid',
            variableUuid: 'variable-uuid',
            value: 'value',
          ),
        ),
      act: (cubit) => cubit.delete(
        const BranchVariableValue(
          uuid: 'a-uuid',
          branchUuid: 'branch-uuid',
          variableUuid: 'variable-uuid',
          value: 'value',
        ),
      ),
      expect: () => [
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.changing,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'a-uuid',
                branchUuid: 'branch-uuid',
                variableUuid: 'variable-uuid',
                value: 'value',
              )
            ],
          ),
        ),
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.deleted,
            branchVariableValues: const [],
          ),
        )
      ],
    );

    blocTest<BranchVariableValuesCubit, BranchVariableValuesState>(
      'delete failed not found',
      build: () => BranchVariableValuesCubit(dataStoreRepository: dataStoreRepository)
        ..add(
          const BranchVariableValue(
            uuid: 'a-uuid',
            branchUuid: 'branch-uuid',
            variableUuid: 'variable-uuid',
            value: 'value',
          ),
        ),
      act: (cubit) => cubit.delete(
        const BranchVariableValue(
          uuid: 'a-uuid-2',
          branchUuid: 'branch-uuid',
          variableUuid: 'variable-uuid',
          value: 'value',
        ),
      ),
      expect: () => [
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.changing,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'a-uuid',
                branchUuid: 'branch-uuid',
                variableUuid: 'variable-uuid',
                value: 'value',
              )
            ],
          ),
        ),
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.deleteFailedNotFound,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'a-uuid',
                branchUuid: 'branch-uuid',
                variableUuid: 'variable-uuid',
                value: 'value',
              ),
            ],
          ),
        )
      ],
    );

    blocTest<BranchVariableValuesCubit, BranchVariableValuesState>(
      'load from datastore',
      setUp: () {
        dataStoreRepository.load('a-file.json');
      },
      build: () => BranchVariableValuesCubit(
        dataStoreRepository: dataStoreRepository,
      ),
      act: (cubit) => cubit.load(dataStoreRepository),
      expect: () => [
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.changing,
            branchVariableValues: const [],
          ),
        ),
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.loaded,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'a-uuid',
                branchUuid: 'branch-uuid-1',
                variableUuid: 'variable-uuid',
                value: 'value',
              ),
              BranchVariableValue(
                uuid: 'a-uuid-2',
                branchUuid: 'branch-uuid-2',
                variableUuid: 'variable-uuid',
                value: 'value',
              ),
            ],
          ),
        ),
      ],
    );

    test('test get ', () {
      final cubit = BranchVariableValuesCubit(
        dataStoreRepository: dataStoreRepository,
      )
        ..add(
          const BranchVariableValue(
            uuid: 'a-uuid',
            branchUuid: 'branch-uuid-1',
            variableUuid: 'variable-uuid',
            value: 'value',
          ),
        )
        ..add(
          const BranchVariableValue(
            uuid: 'a-uuid-2',
            branchUuid: 'branch-uuid-2',
            variableUuid: 'variable-uuid',
            value: 'value',
          ),
        );

      expect(cubit.getBranchVariableValue('unknown'), isNull);
      expect(
        cubit.getBranchVariableValue('a-uuid-2'),
        equals(
          const BranchVariableValue(
            uuid: 'a-uuid-2',
            branchUuid: 'branch-uuid-2',
            variableUuid: 'variable-uuid',
            value: 'value',
          ),
        ),
      );
      expect(
        cubit.getBranchVariableValue('a-uuid'),
        equals(
          const BranchVariableValue(
            uuid: 'a-uuid',
            branchUuid: 'branch-uuid-1',
            variableUuid: 'variable-uuid',
            value: 'value',
          ),
        ),
      );
    });

    blocTest<BranchVariableValuesCubit, BranchVariableValuesState>(
      'update success',
      build: () => BranchVariableValuesCubit(
        dataStoreRepository: dataStoreRepository,
      )..add(
          const BranchVariableValue(
            uuid: 'a-uuid',
            branchUuid: 'branch-uuid-1',
            variableUuid: 'variable-uuid',
            value: 'value',
          ),
        ),
      act: (cubit) => cubit.updateValue(
        const BranchVariableValue(
          uuid: 'a-uuid',
          branchUuid: 'branch-uuid-1',
          variableUuid: 'variable-uuid',
          value: 'updated value',
        ),
      ),
      expect: () => [
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.changing,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'a-uuid',
                branchUuid: 'branch-uuid-1',
                variableUuid: 'variable-uuid',
                value: 'value',
              ),
            ],
          ),
        ),
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.updated,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'a-uuid',
                branchUuid: 'branch-uuid-1',
                variableUuid: 'variable-uuid',
                value: 'updated value',
              )
            ],
          ),
        )
      ],
    );

    blocTest<BranchVariableValuesCubit, BranchVariableValuesState>(
      'update failed uuid not found',
      build: () => BranchVariableValuesCubit(
        dataStoreRepository: dataStoreRepository,
      )..add(
          const BranchVariableValue(
            uuid: 'a-uuid',
            branchUuid: 'branch-uuid-1',
            variableUuid: 'variable-uuid',
            value: 'value',
          ),
        ),
      act: (cubit) => cubit.updateValue(
        const BranchVariableValue(
          uuid: 'a-uuid-v',
          branchUuid: 'branch-uuid-1',
          variableUuid: 'variable-uuid',
          value: 'updated value',
        ),
      ),
      expect: () => [
        BranchVariableValuesState(
          dataStoreRepository: dataStoreRepository,
          status: BranchVariableValuesStatus.changing,
          branchVariableValues: const [
            BranchVariableValue(
              uuid: 'a-uuid',
              branchUuid: 'branch-uuid-1',
              variableUuid: 'variable-uuid',
              value: 'value',
            ),
          ],
        ),
        equals(
          BranchVariableValuesState(
            dataStoreRepository: dataStoreRepository,
            status: BranchVariableValuesStatus.updateFailedUUIDNotFound,
            branchVariableValues: const [
              BranchVariableValue(
                uuid: 'a-uuid',
                branchUuid: 'branch-uuid-1',
                variableUuid: 'variable-uuid',
                value: 'value',
              )
            ],
          ),
        )
      ],
    );

    test('x test', () {
      var value = BranchVariableValuesStatus.initial;
      expect(value.isInitial, isTrue);
      value = BranchVariableValuesStatus.loaded;
      expect(value.isInitial, isFalse);
      expect(value.isLoaded, isTrue);

      value = BranchVariableValuesStatus.saved;
      expect(value.isSaved, isTrue);

      value = BranchVariableValuesStatus.added;
      expect(value.isAdded, isTrue);

      value = BranchVariableValuesStatus.changing;
      expect(value.isChanging, isTrue);

      value = BranchVariableValuesStatus.addFailedUUIDExists;
      expect(value.isAddFailedUUIDExists, isTrue);

      value = BranchVariableValuesStatus.addFailedUUIDCombinationExists;
      expect(value.isAddFailedUUIDCombinationExists, isTrue);

      value = BranchVariableValuesStatus.deleted;
      expect(value.isDeleted, isTrue);

      value = BranchVariableValuesStatus.deleteFailedNotFound;
      expect(value.isDeleteFailedNotFound, isTrue);

      value = BranchVariableValuesStatus.failure;
      expect(value.isFailure, isTrue);

      value = BranchVariableValuesStatus.updated;
      expect(value.isUpdated, isTrue);

      value = BranchVariableValuesStatus.updateFailedUUIDNotFound;
      expect(value.isUpdateFailedUUIDNotFound, isTrue);
    });
  });
}
