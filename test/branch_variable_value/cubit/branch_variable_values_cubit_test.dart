// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/repositories/data_store_repository.dart';

class MockDataStoreRepository extends Mock implements DataStoreRepository {}

void main() {
  group('BranchVariableValuesCubit', () {
    late DataStoreRepository dataStoreRepository;

    setUp(() {
      dataStoreRepository = MockDataStoreRepository();
    });

    test(
      'initial state is empty list',
      () {
        final cubit = BranchVariableValuesCubit();
        expect(cubit.state, equals(BranchVariableValuesState()));
        expect(cubit.state.branchVariableValues, equals(<BranchVariableValue>[]));
      },
    );

    blocTest<BranchVariableValuesCubit, BranchVariableValuesState>(
      'add success',
      build: () => BranchVariableValuesCubit(),
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
      build: () => BranchVariableValuesCubit(),
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
      build: () => BranchVariableValuesCubit()
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
      build: () => BranchVariableValuesCubit()
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
      build: () => BranchVariableValuesCubit()
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
            status: BranchVariableValuesStatus.deleted,
            branchVariableValues: const [],
          ),
        )
      ],
    );

    blocTest<BranchVariableValuesCubit, BranchVariableValuesState>(
      'delete failed not found',
      build: () => BranchVariableValuesCubit()
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
        when(() => dataStoreRepository.branchVariableValues).thenReturn([
          const BranchVariableValue(
            uuid: 'a-uuid',
            branchUuid: 'branch-uuid-1',
            variableUuid: 'variable-uuid',
            value: 'value',
          ),
          const BranchVariableValue(
            uuid: 'a-uuid-2',
            branchUuid: 'branch-uuid-2',
            variableUuid: 'variable-uuid',
            value: 'value',
          ),
        ]);
      },
      build: () => BranchVariableValuesCubit(),
      act: (cubit) => cubit.load(dataStoreRepository),
      expect: () => [
        equals(
          BranchVariableValuesState(
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

    blocTest<BranchVariableValuesCubit, BranchVariableValuesState>(
      'save to datastore',
      setUp: () {},
      build: () => BranchVariableValuesCubit()
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
        ),
      act: (cubit) => cubit.save(dataStoreRepository),
      expect: () => [
        equals(
          BranchVariableValuesState(
            status: BranchVariableValuesStatus.saved,
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
      final cubit = BranchVariableValuesCubit()
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
      build: () => BranchVariableValuesCubit()
        ..add(
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
      build: () => BranchVariableValuesCubit()
        ..add(
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
        equals(
          BranchVariableValuesState(
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
