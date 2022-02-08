import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/repositories/json_storage.dart';
import 'package:overscript/variable/variable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('JsonStorage', () {
    late GitBranch mockGitBranch1;
    late GitBranch mockGitBranch2;
    late Variable mockVariable1;
    late Variable mockVariable2;
    late BranchVariableValue mockBranchVariableValue1;
    late BranchVariableValue mockBranchVariableValue2;

    setUp(() {
      mockGitBranch1 = const GitBranch(
        uuid: 'a-uuid-1',
        name: 'master',
        directory: '/home/user/src/project',
        origin: 'git:someplace/bob',
      );

      mockGitBranch2 = const GitBranch(
        uuid: 'a-uuid-2',
        name: 'branch-one',
        directory: '/home/user/src/banch1',
        origin: 'git:someplace/bob',
      );

      mockVariable1 = const Variable(
        uuid: 'v-uuid-1',
        name: 'variable1',
        defaultValue: 'default1',
      );

      mockVariable2 = const Variable(
        uuid: 'v-uuid-2',
        name: 'variable2',
        defaultValue: 'default2',
      );

      mockBranchVariableValue1 = const BranchVariableValue(
        uuid: 'bvv-uuid-1',
        branchUuid: 'a-uuid-1',
        variableUuid: 'v-uuid-1',
        value: 'start value 1',
      );

      mockBranchVariableValue2 = const BranchVariableValue(
        uuid: 'bvv-uuid-2',
        branchUuid: 'a-uuid-2',
        variableUuid: 'v-uuid-1',
        value: 'start value 2',
      );
    });

    test('empty', () {
      const value = JsonStorage.empty();
      expect(value.scripts, equals([]));
      expect(value.variables, equals([]));
      expect(value.branches, equals([]));
      expect(value.branchVariableValues, equals([]));
    });

    test('constructor', () {
      final value = JsonStorage(
        branchVariableValues: [
          mockBranchVariableValue1,
          mockBranchVariableValue2,
        ],
        branches: [
          mockGitBranch1,
          mockGitBranch2,
        ],
        variables: [
          mockVariable1,
          mockVariable2,
        ],
        scripts: const [],
      );
      expect(
        value.scripts,
        equals(
          [],
        ),
      );

      expect(
        value.variables,
        equals(
          [
            mockVariable1,
            mockVariable2,
          ],
        ),
      );

      expect(
        value.branches,
        equals(
          [
            mockGitBranch1,
            mockGitBranch2,
          ],
        ),
      );

      expect(
        value.branchVariableValues,
        equals(
          [
            mockBranchVariableValue1,
            mockBranchVariableValue2,
          ],
        ),
      );

      expect(
        value.props,
        equals(
          [
            [],
            [
              mockVariable1,
              mockVariable2,
            ],
            [
              mockGitBranch1,
              mockGitBranch2,
            ],
            [
              mockBranchVariableValue1,
              mockBranchVariableValue2,
            ],
          ],
        ),
      );
    });

    test('toJson', () {
      final value = JsonStorage(
        branchVariableValues: [
          mockBranchVariableValue1,
          mockBranchVariableValue2,
        ],
        branches: [
          mockGitBranch1,
          mockGitBranch2,
        ],
        variables: [
          mockVariable1,
          mockVariable2,
        ],
        scripts: const [],
      );
      final jsonValues = value.toJson();
      expect(
        jsonValues['scripts'],
        equals(
          [],
        ),
      );
      expect(
        jsonValues['variables'],
        equals(
          [
            mockVariable1,
            mockVariable2,
          ],
        ),
      );
      expect(
        jsonValues['branches'],
        equals(
          [
            mockGitBranch1,
            mockGitBranch2,
          ],
        ),
      );
      expect(
        jsonValues['branchVariableValues'],
        equals(
          [
            mockBranchVariableValue1,
            mockBranchVariableValue2,
          ],
        ),
      );
    });

    test('fromJson', () {
      final jsonValues = <String, dynamic>{};
      jsonValues['scripts'] = [];
      jsonValues['variables'] = [
        mockVariable1.toJson(),
        mockVariable2.toJson(),
      ];
      jsonValues['branches'] = [
        mockGitBranch1.toJson(),
        mockGitBranch2.toJson(),
      ];
      jsonValues['branchVariableValues'] = [
        mockBranchVariableValue1.toJson(),
        mockBranchVariableValue2.toJson(),
      ];

      final value = JsonStorage.fromJson(jsonValues);
      expect(
        value.props,
        equals(
          [
            [],
            [
              mockVariable1,
              mockVariable2,
            ],
            [
              mockGitBranch1,
              mockGitBranch2,
            ],
            [
              mockBranchVariableValue1,
              mockBranchVariableValue2,
            ],
          ],
        ),
      );
    });

    test('toString', () {
      final value = JsonStorage(
        branchVariableValues: [
          mockBranchVariableValue1,
          mockBranchVariableValue2,
        ],
        branches: [
          mockGitBranch1,
          mockGitBranch2,
        ],
        variables: [
          mockVariable1,
          mockVariable2,
        ],
        scripts: const [],
      );
      final jsonString = value.toString();
      expect(
          jsonString,
          equals(
              '{scripts: [], variables: [{uuid: v-uuid-1, name: variable1, defaultValue: default1}, {uuid: v-uuid-2, name: variable2, defaultValue: default2}], branches: [{uuid: a-uuid-1, name: master, directory: /home/user/src/project, origin: git:someplace/bob}, {uuid: a-uuid-2, name: branch-one, directory: /home/user/src/banch1, origin: git:someplace/bob}], branchVariableValues: [{uuid: bvv-uuid-1, branchUuid: a-uuid-1, variableUuid: v-uuid-1, value: start value 1}, {uuid: bvv-uuid-2, branchUuid: a-uuid-2, variableUuid: v-uuid-1, value: start value 2}]}'));
    });
  });
}