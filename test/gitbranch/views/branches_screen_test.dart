import 'package:bloc_test/bloc_test.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/gitbranch/views/branch_list_item.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';

import '../../helpers/helpers.dart';

class MockDataStoreRepository extends Mock implements DataStoreRepository {}

class MockGitBranchesCubit extends MockCubit<GitBranchesState> implements GitBranchesCubit {}

class MockGitBranchesState extends Mock implements GitBranchesState {}

class MockGitBranch extends Mock implements GitBranch {}

class MockGitCalls extends Mock implements GitCalls {}

abstract class ResultTest {
  void onResult(String value);
}

class MockResultTest extends Mock implements ResultTest {}

void main() {
  group('BranchesScreen', () {
    late MockGitBranch mockGitBranch1;
    late MockGitBranch mockGitBranch2;
    late MockGitBranchesCubit mockGitBranchesCubit;
    late MockDataStoreRepository mockDataStoreRepository;
    late MockGitBranchesState mockGitBranchesState;
    late MockGitCalls mockGitCalls;
    late FakeFileSelector fakeFileSelectorImplementation;

    setUp(() {
      mockDataStoreRepository = MockDataStoreRepository();
      mockGitBranchesState = MockGitBranchesState();
      mockGitBranchesCubit = MockGitBranchesCubit();
      mockGitCalls = MockGitCalls();

      mockGitBranch1 = MockGitBranch();
      when(() => mockGitBranch1.uuid).thenReturn('a-uuid-1');
      when(() => mockGitBranch1.name).thenReturn('master');
      when(() => mockGitBranch1.directory).thenReturn('/home/user/src/project');
      when(() => mockGitBranch1.origin).thenReturn('git:someplace/bob');

      mockGitBranch2 = MockGitBranch();
      when(() => mockGitBranch2.uuid).thenReturn('a-uuid-2');
      when(() => mockGitBranch2.name).thenReturn('branch-a');
      when(() => mockGitBranch2.directory).thenReturn('/home/user/src/project-branch-a');
      when(() => mockGitBranch2.origin).thenReturn('git:someplace/bob');

      when(() => mockGitBranchesState.status).thenReturn(GitBranchesStatus.loaded);
      when(() => mockGitBranchesState.branches).thenReturn([mockGitBranch1, mockGitBranch2]);

      when(() => mockGitBranchesCubit.state).thenReturn(mockGitBranchesState);

      registerFallbackValue(const GitBranch.empty());

      fakeFileSelectorImplementation = FakeFileSelector();
      FileSelectorPlatform.instance = fakeFileSelectorImplementation;
    });

    testWidgets('create and show branches', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(create: (context) => mockGitCalls),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<GitBranchesCubit>(
                create: (context) => mockGitBranchesCubit,
              ),
            ],
            child: const BranchesScreen(),
          ),
        ),
      );

      expect(find.byType(BranchesScreen), findsOneWidget);
      expect(find.byType(BranchListItem), findsNWidgets(2));

      expect(find.text('master'), findsOneWidget);
      expect(find.text('/home/user/src/project'), findsOneWidget);

      expect(find.text('branch-a'), findsOneWidget);
      expect(find.text('/home/user/src/project-branch-a'), findsOneWidget);
    });

    testWidgets('select delete enables and disables', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(create: (context) => mockGitCalls),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<GitBranchesCubit>(
                create: (context) => mockGitBranchesCubit,
              ),
            ],
            child: const BranchesScreen(),
          ),
        ),
      );

      expect(
        tester.widget<IconButton>(find.byKey(const Key('DeleteIcon'))).color,
        equals(ThemeData.light().disabledColor),
      );

      await tester.tap(find.text('master'));

      await tester.pump();

      expect(
        tester.widget<IconButton>(find.byKey(const Key('DeleteIcon'))).color,
        equals(ThemeData.light().iconTheme.color),
      );

      await tester.tap(find.text('branch-a'));

      await tester.pump();

      expect(
        tester.widget<IconButton>(find.byKey(const Key('DeleteIcon'))).color,
        equals(ThemeData.light().iconTheme.color),
      );

      await tester.tap(find.text('master'));

      await tester.pump();

      expect(
        tester.widget<IconButton>(find.byKey(const Key('DeleteIcon'))).color,
        equals(ThemeData.light().iconTheme.color),
      );

      await tester.tap(find.text('branch-a'));

      await tester.pump();

      expect(
        tester.widget<IconButton>(find.byKey(const Key('DeleteIcon'))).color,
        equals(ThemeData.light().disabledColor),
      );
    });

    testWidgets('delete branches click cancel!', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(create: (context) => mockGitCalls),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<GitBranchesCubit>(
                create: (context) => mockGitBranchesCubit,
              ),
            ],
            child: const BranchesScreen(),
          ),
        ),
      );

      await tester.tap(find.text('master'));
      await tester.pump();
      await tester.tap(find.text('branch-a'));
      await tester.pump();
      expect(
        tester.widget<IconButton>(find.byKey(const Key('DeleteIcon'))).color,
        equals(ThemeData.light().iconTheme.color),
      );

      await tester.tap(find.byKey(const Key('DeleteIcon')));
      await tester.pumpAndSettle();

      expect(find.text('Delete Branches?'), findsOneWidget);
      final names = StringBuffer()
        ..writeln('master')
        ..writeln('branch-a');
      expect(find.text(names.toString()), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.press(find.text('Cancel'));
      await tester.pump();

      verifyNever(() => mockGitBranchesCubit.delete(mockGitBranch1));
      verifyNever(() => mockGitBranchesCubit.delete(mockGitBranch2));
    });

    testWidgets('delete branches click ok!', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(create: (context) => mockGitCalls),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<GitBranchesCubit>(
                create: (context) => mockGitBranchesCubit,
              ),
            ],
            child: const BranchesScreen(),
          ),
        ),
      );

      await tester.tap(find.text('master'));
      await tester.pump();
      await tester.tap(find.text('branch-a'));
      await tester.pump();
      expect(
        tester.widget<IconButton>(find.byKey(const Key('DeleteIcon'))).color,
        equals(ThemeData.light().iconTheme.color),
      );

      await tester.tap(find.byKey(const Key('DeleteIcon')));
      await tester.pumpAndSettle();

      expect(find.text('Delete Branches?'), findsOneWidget);
      final names = StringBuffer()
        ..writeln('master')
        ..writeln('branch-a');
      expect(find.text(names.toString()), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      verify(() => mockGitBranchesCubit.delete(mockGitBranch1)).called(1);
      verify(() => mockGitBranchesCubit.delete(mockGitBranch2)).called(1);
    });

    testWidgets('add "cancel clicked"!', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(create: (context) => mockGitCalls),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<GitBranchesCubit>(
                create: (context) => mockGitBranchesCubit,
              ),
            ],
            child: const BranchesScreen(),
          ),
        ),
      );

      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '~', confirmButtonText: 'Select')
        ..setPathResponse('');

      // when(() => mockGitCalls.getDirectoryPath(confirmButtonText: 'Select')).thenAnswer((invocation) => Future.value(null));

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      verifyNever(() => mockGitBranchesCubit.add(any<GitBranch>()));
    });

    testWidgets('add "ok clicked", "Not a git repository', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(create: (context) => mockGitCalls),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<GitBranchesCubit>(
                create: (context) => mockGitBranchesCubit,
              ),
            ],
            child: const BranchesScreen(),
          ),
        ),
      );

      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '~', confirmButtonText: 'Select')
        ..setPathResponse('/a/non/git/path');

      //when(() => getDirectoryPath(confirmButtonText: 'Select')).thenAnswer((invocation) => Future.value('/a/non/git/path'));
      when(() => mockGitCalls.getBranchName('/a/non/git/path')).thenAnswer((invocation) => Future.error('bad'));

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      expect(find.text('Add Branch'), findsOneWidget);
      expect(
        find.text(
          'You must select a directory that has a git repository.\n\nbad',
        ),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsNothing);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      verifyNever(() => mockGitBranchesCubit.add(any<GitBranch>()));
    });

    testWidgets('add "ok clicked", "Not a same origin', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(create: (context) => mockGitCalls),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<GitBranchesCubit>(
                create: (context) => mockGitBranchesCubit,
              ),
            ],
            child: const BranchesScreen(),
          ),
        ),
      );

      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '~', confirmButtonText: 'Select')
        ..setPathResponse('/a/non/git/path');

      // when(() => mockGitCalls.getDirectoryPath(confirmButtonText: 'Select')).thenAnswer((invocation) => Future.value('/a/non/git/path'));
      when(() => mockGitCalls.getBranchName('/a/non/git/path')).thenAnswer((invocation) => Future.value('peaches'));
      when(() => mockGitCalls.getOriginRemote('/a/non/git/path')).thenAnswer((invocation) => Future.error('No remote origin\n\nbad'));

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      expect(find.text('Add Branch'), findsOneWidget);
      expect(find.text('No remote origin\n\nbad'), findsOneWidget);
      expect(find.text('Cancel'), findsNothing);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      verifyNever(() => mockGitBranchesCubit.add(any<GitBranch>()));
    });

    testWidgets('add "ok clicked", "All OK', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(create: (context) => mockGitCalls),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<GitBranchesCubit>(
                create: (context) => mockGitBranchesCubit,
              ),
            ],
            child: const BranchesScreen(),
          ),
        ),
      );

      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '~', confirmButtonText: 'Select')
        ..setPathResponse('/a/non/git/path');

      when(() => mockGitCalls.getBranchName('/a/non/git/path')).thenAnswer((invocation) => Future.value('peaches'));
      when(() => mockGitCalls.getOriginRemote('/a/non/git/path')).thenAnswer((invocation) => Future.value('anorigin'));

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      final captured = verify(() => mockGitBranchesCubit.add(captureAny<GitBranch>())).captured;
      final branch = captured.last as GitBranch;

      expect(branch.uuid, isNotEmpty);
      expect(branch.name, equals('peaches'));
      expect(branch.directory, equals('/a/non/git/path'));
      expect(branch.origin, equals('anorigin'));
    });

    testWidgets('test page route', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(create: (context) => mockGitCalls),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<GitBranchesCubit>(
                create: (context) => mockGitBranchesCubit,
              ),
            ],
            child: const TestApp(),
          ),
        ),
      );

      expect(find.byType(BranchesScreen), findsNothing);

      await tester.tap(find.text('ClickMe'));
      await tester.pumpAndSettle();

      expect(find.byType(BranchesScreen), findsOneWidget);
      expect(find.byType(BranchListItem), findsNWidgets(2));
    });
  });
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case BranchesScreen.routeName:
            return BranchesScreen.pageRoute(context);
        }
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const DummyHomeRoute(),
    );
  }
}

class DummyHomeRoute extends StatelessWidget {
  const DummyHomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: () => Navigator.of(context).pushNamed(BranchesScreen.routeName),
        child: const Text('ClickMe'),
      );
}
