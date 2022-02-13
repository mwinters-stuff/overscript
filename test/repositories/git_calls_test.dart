import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/repositories/repositories.dart';

import '../helpers/helpers.dart';

void main() {
  group('GitCalls', () {
    test('getBranchName Success', () {
      final mockProcessManager = MockProcessManager();
      final mockProcessResult = MockProcessResult();

      when(() => mockProcessResult.stderr).thenReturn('');
      when(() => mockProcessResult.stdout).thenReturn('master');
      when(
        () => mockProcessManager.runSync(
          ['git', '-C', '/some/git/repository', 'rev-parse', '--abbrev-ref', 'HEAD'],
        ),
      ).thenReturn(mockProcessResult);
      final gitCalls = GitCalls(mockProcessManager);

      expect(gitCalls.getBranchName('/some/git/repository'), completion(equals('master')));
    });

    test('getBranchName Fail', () async {
      final mockProcessManager = MockProcessManager();
      final mockProcessResult = MockProcessResult();

      when(() => mockProcessResult.stderr).thenReturn('fatal: not a git repository (or any of the parent directories): .git');
      when(() => mockProcessResult.stdout).thenReturn('');
      when(
        () => mockProcessManager.runSync(
          ['git', '-C', '/some/not/repository', 'rev-parse', '--abbrev-ref', 'HEAD'],
        ),
      ).thenReturn(mockProcessResult);
      final gitCalls = GitCalls(mockProcessManager);

      expect(gitCalls.getBranchName('/some/not/repository'), throwsA(equals('fatal: not a git repository (or any of the parent directories): .git')));
    });

    test('getOriginRemote Success', () {
      final mockProcessManager = MockProcessManager();
      final mockProcessResult = MockProcessResult();

      when(() => mockProcessResult.stderr).thenReturn('');
      when(() => mockProcessResult.stdout).thenReturn('origin\thttps://github.com/mwinters-stuff/overscript.git (fetch)\norigin\thttps://github.com/mwinters-stuff/overscript.git (push)');
      when(
        () => mockProcessManager.runSync(
          ['git', '-C', '/some/git/repository', 'remote', '-v'],
        ),
      ).thenReturn(mockProcessResult);
      final gitCalls = GitCalls(mockProcessManager);

      expect(gitCalls.getOriginRemote('/some/git/repository'), completion(equals('https://github.com/mwinters-stuff/overscript.git')));
    });

    test('getOriginRemote Fail', () {
      final mockProcessManager = MockProcessManager();
      final mockProcessResult = MockProcessResult();

      when(() => mockProcessResult.stderr).thenReturn('fatal: not a git repository (or any of the parent directories): .git');
      when(() => mockProcessResult.stdout).thenReturn('');
      when(
        () => mockProcessManager.runSync(
          ['git', '-C', '/some/not/repository', 'remote', '-v'],
        ),
      ).thenReturn(mockProcessResult);
      final gitCalls = GitCalls(mockProcessManager);

      expect(gitCalls.getOriginRemote('/some/not/repository'), throwsA(equals('fatal: not a git repository (or any of the parent directories): .git')));
    });

    test('getOriginRemote Fail bad input', () {
      final mockProcessManager = MockProcessManager();
      final mockProcessResult = MockProcessResult();

      when(() => mockProcessResult.stderr).thenReturn('');
      when(() => mockProcessResult.stdout).thenReturn('some funny squittly result that git might throw out');
      when(
        () => mockProcessManager.runSync(
          ['git', '-C', '/some/git/repository', 'remote', '-v'],
        ),
      ).thenReturn(mockProcessResult);
      final gitCalls = GitCalls(mockProcessManager);

      expect(gitCalls.getOriginRemote('/some/git/repository'), throwsA(equals('No remote origin\n\nsome funny squittly result that git might throw out')));
    });
  });
}
