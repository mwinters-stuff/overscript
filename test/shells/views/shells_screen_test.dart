import 'package:file/file.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/shells/shells.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShellsScreen', () {
    late MockShell mockShell1;
    late MockShell mockShell2;
    late MockShellsCubit mockShellsCubit;
    late MockShellsState mockShellsState;
    late MockDataStoreRepository mockDataStoreRepository;
    late FakeFileSelector fakeFileSelectorImplementation;
    late MockFileSystem mockFileSystem;

    setUp(() {
      mockDataStoreRepository = MockDataStoreRepository();
      mockShellsState = MockShellsState();
      mockShellsCubit = MockShellsCubit();
      mockFileSystem = MockFileSystem();

      when(() => mockDataStoreRepository.save(any())).thenAnswer((_) => Future.value(true));
      when(() => mockDataStoreRepository.load(any())).thenAnswer((_) => Future.value(true));

      mockShell1 = MockShell();
      when(() => mockShell1.uuid).thenReturn('a-uuid-1');
      when(() => mockShell1.command).thenReturn('/usr/bin/bash');
      when(() => mockShell1.args).thenReturn(['arg1', 'arg2']);

      mockShell2 = MockShell();
      when(() => mockShell2.uuid).thenReturn('a-uuid-2');
      when(() => mockShell2.command).thenReturn('/usr/bin/ash');
      when(() => mockShell2.args).thenReturn(['arg1']);

      when(() => mockShellsState.status).thenReturn(ShellsStatus.loaded);
      when(() => mockShellsState.shells).thenReturn([mockShell1, mockShell2]);

      when(() => mockShellsCubit.state).thenReturn(mockShellsState);

      when(() => mockFileSystem.isFileSync('/usr/bin/bash')).thenReturn(true);

      registerFallbackValue(const Shell.empty());
      fakeFileSelectorImplementation = FakeFileSelector();
      FileSelectorPlatform.instance = fakeFileSelectorImplementation;
    });

    Future<int> pumpApp(WidgetTester tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<FileSystem>(
              create: (context) => mockFileSystem,
            )
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ShellsCubit>(
                create: (context) => mockShellsCubit,
              ),
            ],
            child: const ShellsScreen(),
          ),
        ),
      );

      return tester.pumpAndSettle();
    }

    testWidgets('create and show shells', (tester) async {
      await pumpApp(tester);
      expect(find.byType(ShellsScreen), findsOneWidget);
      expect(find.byType(ShellListItem), findsNWidgets(2));

      expect(find.text('Shells'), findsOneWidget);

      expect(find.text('/usr/bin/bash'), findsOneWidget);
      expect(find.text('Arguments: arg1 arg2'), findsOneWidget);

      expect(find.text('/usr/bin/ash'), findsOneWidget);
      expect(find.text('Arguments: arg1'), findsOneWidget);
    });

    testWidgets('add "cancel clicked"!', (tester) async {
      await pumpApp(tester);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('commandInput')), findsOneWidget);
      expect(find.byKey(const Key('argsInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => mockShellsCubit.add(any<Shell>()));
    });

    testWidgets('add "ok clicked", "All OK', (tester) async {
      await pumpApp(tester);
      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('commandInput')), findsOneWidget);
      expect(find.byKey(const Key('argsInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('commandInput')), '/usr/bin/bash');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('argsInput')), 'pears peaches apples');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      final captured = verify(() => mockShellsCubit.add(captureAny<Shell>())).captured;
      final shell = captured.last as Shell;

      expect(shell.uuid, isNotEmpty);
      expect(shell.command, equals('/usr/bin/bash'));
      expect(shell.args, equals(['pears', 'peaches', 'apples']));
    });

    testWidgets('add using file browser', (tester) async {
      await pumpApp(tester);
      await tester.pumpAndSettle();

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '.', confirmButtonText: 'Select', suggestedName: '')
        ..setPathResponse('/usr/bin/bash');

      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('commandInput')), findsOneWidget);
      expect(find.byKey(const Key('argsInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.byKey(const Key('commandInput')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('selectFileButton')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('argsInput')), 'pears peaches apples');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      final captured = verify(() => mockShellsCubit.add(captureAny<Shell>())).captured;
      final shell = captured.last as Shell;

      expect(shell.uuid, isNotEmpty);
      expect(shell.command, equals('/usr/bin/bash'));
      expect(shell.args, equals(['pears', 'peaches', 'apples']));
    });

    testWidgets('test page route', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ShellsCubit>(
                create: (context) => mockShellsCubit,
              ),
            ],
            child: const TestApp(),
          ),
        ),
      );

      expect(find.byType(ShellsScreen), findsNothing);

      await tester.tap(find.text('ClickMe'));
      await tester.pumpAndSettle();

      expect(find.byType(ShellsScreen), findsOneWidget);
      expect(find.byType(ShellListItem), findsNWidgets(2));
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
          case ShellsScreen.routeName:
            return ShellsScreen.pageRoute(context);
        }
        return null;
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
        onPressed: () => Navigator.of(context).pushNamed(ShellsScreen.routeName),
        child: const Text('ClickMe'),
      );
}
