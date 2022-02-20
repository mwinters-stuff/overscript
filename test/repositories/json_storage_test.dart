import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/repositories/json_storage.dart';

import '../helpers/helpers.dart';

void main() {
  group('JsonStorage', () {
    setUp(() {});

    test('empty', () {
      const value = JsonStorage.empty();
      expect(value.scripts, equals([]));
      expect(value.branchVariables, equals([]));
      expect(value.gitBranches, equals([]));
      expect(value.branchVariableValues, equals([]));
      expect(value.globalVariables, equals([]));
      expect(value.globalEnvironmentVariables, equals([]));
    });

    test('constructor', () {
      final value = JsonStorage(
        branchVariableValues: [
          mockBranchVariableValue1,
          mockBranchVariableValue2,
        ],
        gitBranches: [
          mockGitBranch1,
          mockGitBranch2,
        ],
        branchVariables: [
          mockVariable1,
          mockVariable2,
        ],
        scripts: const [],
        globalVariables: [
          mockGlobalVariable1,
          mockGlobalVariable2,
        ],
        globalEnvironmentVariables: [
          mockGlobalEnvironmentVariable1,
          mockGlobalEnvironmentVariable2,
        ],
      );
      expect(
        value.scripts,
        equals(
          [],
        ),
      );

      expect(
        value.globalVariables,
        equals(
          [
            mockGlobalVariable1,
            mockGlobalVariable2,
          ],
        ),
      );

      expect(
        value.globalEnvironmentVariables,
        equals(
          [
            mockGlobalEnvironmentVariable1,
            mockGlobalEnvironmentVariable2,
          ],
        ),
      );

      expect(
        value.branchVariables,
        equals(
          [
            mockVariable1,
            mockVariable2,
          ],
        ),
      );

      expect(
        value.gitBranches,
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
            [
              mockGlobalVariable1,
              mockGlobalVariable2,
            ],
            [
              mockGlobalEnvironmentVariable1,
              mockGlobalEnvironmentVariable2,
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
        gitBranches: [
          mockGitBranch1,
          mockGitBranch2,
        ],
        branchVariables: [
          mockVariable1,
          mockVariable2,
        ],
        scripts: const [],
        globalVariables: [
          mockGlobalVariable1,
          mockGlobalVariable2,
        ],
        globalEnvironmentVariables: [
          mockGlobalEnvironmentVariable1,
          mockGlobalEnvironmentVariable2,
        ],
      );
      final jsonValues = value.toJson();
      expect(
        jsonValues['scripts'],
        equals(
          [],
        ),
      );
      expect(
        jsonValues['branchVariables'],
        equals(
          [
            mockVariable1,
            mockVariable2,
          ],
        ),
      );
      expect(
        jsonValues['gitBranches'],
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
      expect(
        jsonValues['globalVariables'],
        equals(
          [
            mockGlobalVariable1,
            mockGlobalVariable2,
          ],
        ),
      );
      expect(
        jsonValues['globalEnvironmentVariables'],
        equals(
          [
            mockGlobalEnvironmentVariable1,
            mockGlobalEnvironmentVariable2,
          ],
        ),
      );
    });

    test('fromJson', () {
      final jsonValues = <String, dynamic>{};
      jsonValues['scripts'] = [];
      jsonValues['branchVariables'] = [
        mockVariable1.toJson(),
        mockVariable2.toJson(),
      ];
      jsonValues['gitBranches'] = [
        mockGitBranch1.toJson(),
        mockGitBranch2.toJson(),
      ];
      jsonValues['branchVariableValues'] = [
        mockBranchVariableValue1.toJson(),
        mockBranchVariableValue2.toJson(),
      ];
      jsonValues['globalVariables'] = [
        mockGlobalVariable1.toJson(),
        mockGlobalVariable2.toJson(),
      ];
      jsonValues['globalEnvironmentVariables'] = [
        mockGlobalEnvironmentVariable1.toJson(),
        mockGlobalEnvironmentVariable2.toJson(),
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
            [
              mockGlobalVariable1,
              mockGlobalVariable2,
            ],
            [
              mockGlobalEnvironmentVariable1,
              mockGlobalEnvironmentVariable2,
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
        gitBranches: [
          mockGitBranch1,
          mockGitBranch2,
        ],
        branchVariables: [
          mockVariable1,
          mockVariable2,
        ],
        scripts: const [],
        globalVariables: [
          mockGlobalVariable1,
          mockGlobalVariable2,
        ],
        globalEnvironmentVariables: [
          mockGlobalEnvironmentVariable1,
          mockGlobalEnvironmentVariable2,
        ],
      );
      final jsonString = value.toString();
      expect(
        jsonString,
        equals(fileContents),
      );
    });
  });
}
