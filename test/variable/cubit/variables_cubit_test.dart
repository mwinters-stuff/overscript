// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/repositories/data_store_repository.dart';
import 'package:overscript/variable/cubit/variable.dart';
import 'package:overscript/variable/cubit/variables_cubit.dart';

class MockDataStoreRepository extends Mock implements DataStoreRepository {}

void main() {
  group('VariablesCubit', () {
    late DataStoreRepository dataStoreRepository;

    setUp(() {
      dataStoreRepository = MockDataStoreRepository();
    });

    test(
      'initial state is empty list',
      () {
        final cubit = VariablesCubit();
        expect(cubit.state, equals(VariablesState()));
        expect(cubit.state.variables, equals(<Variable>[]));
      },
    );

    blocTest<VariablesCubit, VariablesState>(
      'add success',
      build: () => VariablesCubit(),
      act: (cubit) => cubit.add(
        const Variable(
          uuid: 'a-uuid',
          name: 'variable-one',
          defaultValue: '/some/defaultValue',
        ),
      ),
      expect: () => [
        equals(
          VariablesState(
            status: VariablesStatus.added,
            variables: const [
              Variable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              )
            ],
          ),
        )
      ],
    );

    blocTest<VariablesCubit, VariablesState>(
      'add two',
      build: () => VariablesCubit(),
      act: (cubit) {
        cubit
          ..add(
            const Variable(
              uuid: 'a-uuid',
              name: 'variable-one',
              defaultValue: '/some/defaultValue',
            ),
          )
          ..add(
            const Variable(
              uuid: 'a-uuid-2',
              name: 'variable-two',
              defaultValue: '/some/other/defaultValue',
            ),
          );
      },
      expect: () => [
        equals(
          VariablesState(
            status: VariablesStatus.added,
            variables: const [
              Variable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              ),
              Variable(
                uuid: 'a-uuid-2',
                name: 'variable-two',
                defaultValue: '/some/other/defaultValue',
              )
            ],
          ),
        ),
      ],
    );

    blocTest<VariablesCubit, VariablesState>(
      'add uuid already exists',
      build: () => VariablesCubit()
        ..add(
          const Variable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        ),
      act: (cubit) => cubit.add(
        const Variable(
          uuid: 'a-uuid',
          name: 'variable-two',
          defaultValue: '/some/other/defaultValue',
        ),
      ),
      expect: () => [
        equals(
          VariablesState(
            status: VariablesStatus.addFailedUUIDExists,
            variables: const [
              Variable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              )
            ],
          ),
        )
      ],
    );

    blocTest<VariablesCubit, VariablesState>(
      'add name already exists',
      build: () => VariablesCubit()
        ..add(
          const Variable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        ),
      act: (cubit) => cubit.add(
        const Variable(
          uuid: 'a-uuid-2',
          name: 'variable-one',
          defaultValue: '/some/other/defaultValue',
        ),
      ),
      expect: () => [
        equals(
          VariablesState(
            status: VariablesStatus.addFailedNameExists,
            variables: const [
              Variable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              )
            ],
          ),
        )
      ],
    );

    blocTest<VariablesCubit, VariablesState>(
      'delete success',
      build: () => VariablesCubit()
        ..add(
          const Variable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        ),
      act: (cubit) => cubit.delete(
        const Variable(
          uuid: 'a-uuid',
          name: 'variable-one',
          defaultValue: '/some/defaultValue',
        ),
      ),
      expect: () => [
        equals(
          VariablesState(
            status: VariablesStatus.deleted,
            variables: const [],
          ),
        )
      ],
    );

    blocTest<VariablesCubit, VariablesState>(
      'delete failed not found',
      build: () => VariablesCubit()
        ..add(
          const Variable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        ),
      act: (cubit) => cubit.delete(
        const Variable(
          uuid: 'a-uuid-2',
          name: 'variable-one',
          defaultValue: '/some/defaultValue',
        ),
      ),
      expect: () => [
        equals(
          VariablesState(
            status: VariablesStatus.deleteFailedNotFound,
            variables: const [
              Variable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              ),
            ],
          ),
        )
      ],
    );

    blocTest<VariablesCubit, VariablesState>(
      'load from datastore',
      setUp: () {
        when(() => dataStoreRepository.variables).thenReturn(const [
          Variable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
          Variable(
            uuid: 'a-uuid-2',
            name: 'variable-two',
            defaultValue: '/some/other/defaultValue',
          ),
        ]);
      },
      build: () => VariablesCubit(),
      act: (cubit) => cubit.load(dataStoreRepository),
      expect: () => [
        equals(
          VariablesState(
            status: VariablesStatus.loaded,
            variables: const [
              Variable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              ),
              Variable(
                uuid: 'a-uuid-2',
                name: 'variable-two',
                defaultValue: '/some/other/defaultValue',
              ),
            ],
          ),
        ),
      ],
    );

    blocTest<VariablesCubit, VariablesState>(
      'save to datastore',
      setUp: () {},
      build: () => VariablesCubit()
        ..add(
          const Variable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        )
        ..add(
          const Variable(
            uuid: 'a-uuid-2',
            name: 'variable-two',
            defaultValue: '/some/other/defaultValue',
          ),
        ),
      act: (cubit) => cubit.save(dataStoreRepository),
      expect: () => [
        equals(
          VariablesState(
            status: VariablesStatus.saved,
            variables: const [
              Variable(
                uuid: 'a-uuid',
                name: 'variable-one',
                defaultValue: '/some/defaultValue',
              ),
              Variable(
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
      final cubit = VariablesCubit()
        ..add(
          const Variable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        )
        ..add(
          const Variable(
            uuid: 'a-uuid-2',
            name: 'variable-two',
            defaultValue: '/some/other/defaultValue',
          ),
        );

      expect(cubit.getVariable('unknown'), isNull);
      expect(
        cubit.getVariable('a-uuid-2'),
        equals(
          const Variable(
            uuid: 'a-uuid-2',
            name: 'variable-two',
            defaultValue: '/some/other/defaultValue',
          ),
        ),
      );
      expect(
        cubit.getVariable('a-uuid'),
        equals(
          const Variable(
            uuid: 'a-uuid',
            name: 'variable-one',
            defaultValue: '/some/defaultValue',
          ),
        ),
      );
    });

    test('x test', () {
      var value = VariablesStatus.initial;
      expect(value.isInitial, isTrue);
      value = VariablesStatus.loaded;
      expect(value.isInitial, isFalse);
      expect(value.isLoaded, isTrue);

      value = VariablesStatus.saved;
      expect(value.isSaved, isTrue);

      value = VariablesStatus.added;
      expect(value.isAdded, isTrue);

      value = VariablesStatus.addFailedUUIDExists;
      expect(value.isAddFailedUUIDExists, isTrue);

      value = VariablesStatus.addFailedNameExists;
      expect(value.isAddFailedNameExists, isTrue);

      value = VariablesStatus.deleted;
      expect(value.isDeleted, isTrue);

      value = VariablesStatus.deleteFailedNotFound;
      expect(value.isDeleteFailedNotFound, isTrue);

      value = VariablesStatus.failure;
      expect(value.isFailure, isTrue);
    });
  });
}
