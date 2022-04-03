import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/scripts/scripts.dart';
import 'package:overscript/shells/shells.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ScriptsScreen', () {
    late MockShellsCubit mockShellsCubit;
    late MockScriptsCubit mockScriptsCubit;
    late MockScriptsState mockScriptsState;
    late MockDataStoreRepository mockDataStoreRepository;
    late MockFileSystem mockFileSystem;

    setUp(() {
      mockDataStoreRepository = MockDataStoreRepository();
      mockShellsCubit = MockShellsCubit();

      mockScriptsState = MockScriptsState();
      mockScriptsCubit = MockScriptsCubit();
      mockFileSystem = MockFileSystem();
      initMocks();

      when(() => mockDataStoreRepository.save(any())).thenAnswer((_) => Future.value(true));
      when(() => mockDataStoreRepository.load(any())).thenAnswer((_) => Future.value(true));

      when(() => mockScriptsState.status).thenReturn(ScriptsStatus.loaded);
      when(() => mockScriptsState.scripts).thenReturn([mockScript1, mockScript2]);

      when(() => mockScriptsCubit.state).thenReturn(mockScriptsState);

      when(() => mockShellsCubit.get('sh-uuid-1')).thenReturn(mockShell1);
      when(() => mockShellsCubit.get('sh-uuid-2')).thenReturn(mockShell2);

      registerFallbackValue(const Script.empty());
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
              BlocProvider<ScriptsCubit>(
                create: (context) => mockScriptsCubit,
              ),
            ],
            child: const ScriptsScreen(),
          ),
        ),
      );

      return tester.pumpAndSettle();
    }

    testWidgets('create and show scripts', (tester) async {
      await pumpApp(tester);
      expect(find.byType(ScriptsScreen), findsOneWidget);
      expect(find.byType(ScriptListItem), findsNWidgets(2));

      expect(find.text('Scripts'), findsOneWidget);

      expect(find.text('script-1'), findsOneWidget);
      expect(find.text('command-1 arg-1 arg-2 arg-3'), findsOneWidget);

      expect(find.text('script-2'), findsOneWidget);
      expect(find.text('command-2 arg-1 arg-2'), findsOneWidget);
    });

    // testWidgets('add "cancel clicked"!', (tester) async {
    //   await pumpApp(tester);
    //   await tester.pumpAndSettle();

    //   expect(find.byKey(const Key('AddIcon')), findsOneWidget);

    //   await tester.tap(find.byKey(const Key('AddIcon')));
    //   await tester.pumpAndSettle();

    //   expect(find.byKey(const Key('commandInput')), findsOneWidget);
    //   expect(find.byKey(const Key('argsInput')), findsOneWidget);

    //   expect(find.text('Cancel'), findsOneWidget);
    //   expect(find.text('Ok'), findsOneWidget);

    //   await tester.tap(find.text('Cancel'));
    //   await tester.pumpAndSettle();

    //   verifyNever(() => mockScriptsCubit.add(any<Shell>()));
    // });

    // testWidgets('add "ok clicked", "All OK', (tester) async {
    //   await pumpApp(tester);
    //   expect(find.byKey(const Key('AddIcon')), findsOneWidget);

    //   await tester.tap(find.byKey(const Key('AddIcon')));
    //   await tester.pumpAndSettle();

    //   expect(find.byKey(const Key('commandInput')), findsOneWidget);
    //   expect(find.byKey(const Key('argsInput')), findsOneWidget);

    //   expect(find.text('Cancel'), findsOneWidget);
    //   expect(find.text('Ok'), findsOneWidget);

    //   await tester.enterText(find.byKey(const Key('commandInput')), '/usr/bin/bash');
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byKey(const Key('argsInput')), 'pears peaches apples');
    //   await tester.pumpAndSettle();

    //   await tester.tap(find.text('Ok'));
    //   await tester.pumpAndSettle();

    //   final captured = verify(() => mockScriptsCubit.add(captureAny<Shell>())).captured;
    //   final shell = captured.last as Shell;

    //   expect(shell.uuid, isNotEmpty);
    //   expect(shell.command, equals('/usr/bin/bash'));
    //   expect(shell.args, equals(['pears', 'peaches', 'apples']));
    // });

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
              BlocProvider<ScriptsCubit>(
                create: (context) => mockScriptsCubit,
              ),
              BlocProvider<ShellsCubit>(
                create: (context) => mockShellsCubit,
              ),
            ],
            child: const TestApp(),
          ),
        ),
      );

      expect(find.byType(ScriptsScreen), findsNothing);

      await tester.tap(find.text('ClickMe'));
      await tester.pumpAndSettle();

      expect(find.byType(ScriptsScreen), findsOneWidget);
      expect(find.byType(ScriptListItem), findsNWidgets(2));
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
          case ScriptsScreen.routeName:
            return ScriptsScreen.pageRoute(context);
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
        onPressed: () => Navigator.of(context).pushNamed(ScriptsScreen.routeName),
        child: const Text('ClickMe'),
      );
}
