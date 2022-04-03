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
          realBranchVariableValue1,
          realBranchVariableValue2,
        ],
        gitBranches: [
          realGitBranch1,
          realGitBranch2,
        ],
        branchVariables: [
          realBranchVariable1,
          realBranchVariable2,
        ],
        shells: [
          realShell1,
          realShell2,
        ],
        scripts: [
          realScript1,
          realScript2,
        ],
        globalVariables: [
          realGlobalVariable1,
          realGlobalVariable2,
        ],
        globalEnvironmentVariables: [
          realGlobalEnvironmentVariable1,
          realGlobalEnvironmentVariable2,
        ],
      );
      expect(
        value.scripts,
        equals(
          [
            realScript1,
            realScript2,
          ],
        ),
      );

      expect(
        value.shells,
        equals(
          [
            realShell1,
            realShell2,
          ],
        ),
      );

      expect(
        value.globalVariables,
        equals(
          [
            realGlobalVariable1,
            realGlobalVariable2,
          ],
        ),
      );

      expect(
        value.globalEnvironmentVariables,
        equals(
          [
            realGlobalEnvironmentVariable1,
            realGlobalEnvironmentVariable2,
          ],
        ),
      );

      expect(
        value.branchVariables,
        equals(
          [
            realBranchVariable1,
            realBranchVariable2,
          ],
        ),
      );

      expect(
        value.gitBranches,
        equals(
          [
            realGitBranch1,
            realGitBranch2,
          ],
        ),
      );

      expect(
        value.branchVariableValues,
        equals(
          [
            realBranchVariableValue1,
            realBranchVariableValue2,
          ],
        ),
      );

      expect(
        value.props,
        equals(
          [
            [
              realShell1,
              realShell2,
            ],
            [
              realScript1,
              realScript2,
            ],
            [
              realBranchVariable1,
              realBranchVariable2,
            ],
            [
              realGitBranch1,
              realGitBranch2,
            ],
            [
              realBranchVariableValue1,
              realBranchVariableValue2,
            ],
            [
              realGlobalVariable1,
              realGlobalVariable2,
            ],
            [
              realGlobalEnvironmentVariable1,
              realGlobalEnvironmentVariable2,
            ],
          ],
        ),
      );
    });

    test('toJson', () {
      final value = JsonStorage(
        shells: [
          realShell1,
          realShell2,
        ],
        scripts: [
          realScript1,
          realScript2,
        ],
        branchVariableValues: [
          realBranchVariableValue1,
          realBranchVariableValue2,
        ],
        gitBranches: [
          realGitBranch1,
          realGitBranch2,
        ],
        branchVariables: [
          realBranchVariable1,
          realBranchVariable2,
        ],
        globalVariables: [
          realGlobalVariable1,
          realGlobalVariable2,
        ],
        globalEnvironmentVariables: [
          realGlobalEnvironmentVariable1,
          realGlobalEnvironmentVariable2,
        ],
      );
      final jsonValues = value.toJson();
      expect(
        jsonValues['shells'],
        equals(
          [
            realShell1,
            realShell2,
          ],
        ),
      );
      expect(
        jsonValues['scripts'],
        equals(
          [
            realScript1,
            realScript2,
          ],
        ),
      );
      expect(
        jsonValues['branchVariables'],
        equals(
          [
            realBranchVariable1,
            realBranchVariable2,
          ],
        ),
      );
      expect(
        jsonValues['gitBranches'],
        equals(
          [
            realGitBranch1,
            realGitBranch2,
          ],
        ),
      );
      expect(
        jsonValues['branchVariableValues'],
        equals(
          [
            realBranchVariableValue1,
            realBranchVariableValue2,
          ],
        ),
      );
      expect(
        jsonValues['globalVariables'],
        equals(
          [
            realGlobalVariable1,
            realGlobalVariable2,
          ],
        ),
      );
      expect(
        jsonValues['globalEnvironmentVariables'],
        equals(
          [
            realGlobalEnvironmentVariable1,
            realGlobalEnvironmentVariable2,
          ],
        ),
      );
    });

    test('fromJson', () {
      final jsonValues = <String, dynamic>{};
      jsonValues['shells'] = [
        realShell1.toJson(),
        realShell2.toJson(),
      ];

      jsonValues['scripts'] = [
        realScript1.toJson(),
        realScript2.toJson(),
      ];
      jsonValues['branchVariables'] = [
        realBranchVariable1.toJson(),
        realBranchVariable2.toJson(),
      ];
      jsonValues['gitBranches'] = [
        realGitBranch1.toJson(),
        realGitBranch2.toJson(),
      ];
      jsonValues['branchVariableValues'] = [
        realBranchVariableValue1.toJson(),
        realBranchVariableValue2.toJson(),
      ];
      jsonValues['globalVariables'] = [
        realGlobalVariable1.toJson(),
        realGlobalVariable2.toJson(),
      ];
      jsonValues['globalEnvironmentVariables'] = [
        realGlobalEnvironmentVariable1.toJson(),
        realGlobalEnvironmentVariable2.toJson(),
      ];

      final value = JsonStorage.fromJson(jsonValues);
      expect(
        value.props,
        equals(
          [
            [
              realShell1,
              realShell2,
            ],
            [
              realScript1,
              realScript2,
            ],
            [
              realBranchVariable1,
              realBranchVariable2,
            ],
            [
              realGitBranch1,
              realGitBranch2,
            ],
            [
              realBranchVariableValue1,
              realBranchVariableValue2,
            ],
            [
              realGlobalVariable1,
              realGlobalVariable2,
            ],
            [
              realGlobalEnvironmentVariable1,
              realGlobalEnvironmentVariable2,
            ],
          ],
        ),
      );
    });

    test('toString', () {
      final value = JsonStorage(
        shells: [
          realShell1,
          realShell2,
        ],
        scripts: [
          realScript1,
          realScript2,
        ],
        branchVariableValues: [
          realBranchVariableValue1,
          realBranchVariableValue2,
        ],
        gitBranches: [
          realGitBranch1,
          realGitBranch2,
        ],
        branchVariables: [
          realBranchVariable1,
          realBranchVariable2,
        ],
        globalVariables: [
          realGlobalVariable1,
          realGlobalVariable2,
        ],
        globalEnvironmentVariables: [
          realGlobalEnvironmentVariable1,
          realGlobalEnvironmentVariable2,
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
