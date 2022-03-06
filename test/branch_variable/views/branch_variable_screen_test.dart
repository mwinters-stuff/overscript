import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';

import '../../helpers/helpers.dart';

void main() {
  group('BranchVariablesScreen', () {
    late MockBranchVariable mockVariable1;
    late MockBranchVariable mockVariable2;
    late MockBranchVariablesCubit mockVariablesCubit;
    late MockBranchVariablesState mockVariablesState;
    late MockDataStoreRepository mockDataStoreRepository;
    late MockGitCalls mockGitCalls;
    late MockBranchVariableValuesCubit mockBranchVariableValuesCubit;
    late MockBranchVariableValuesState mockBranchVariableValuesState;
    late MockVariablesHandler mockVariablesHandler;

    setUp(() {
      mockDataStoreRepository = MockDataStoreRepository();
      mockVariablesState = MockBranchVariablesState();
      mockVariablesCubit = MockBranchVariablesCubit();
      mockGitCalls = MockGitCalls();
      mockVariablesHandler = MockVariablesHandler();

      when(() => mockDataStoreRepository.save(any())).thenAnswer((_) => Future.value(true));
      when(() => mockDataStoreRepository.load(any())).thenAnswer((_) => Future.value(true));

      mockVariable1 = MockBranchVariable();
      when(() => mockVariable1.uuid).thenReturn('a-uuid-1');
      when(() => mockVariable1.name).thenReturn('variable-1');
      when(() => mockVariable1.defaultValue).thenReturn('/home/user/src/project');

      mockVariable2 = MockBranchVariable();
      when(() => mockVariable2.uuid).thenReturn('a-uuid-2');
      when(() => mockVariable2.name).thenReturn('variable-2');
      when(() => mockVariable2.defaultValue).thenReturn('/home/user/src/project-branch-a');

      when(() => mockVariablesState.status).thenReturn(BranchVariablesStatus.loaded);
      when(() => mockVariablesState.variables).thenReturn([mockVariable1, mockVariable2]);

      when(() => mockVariablesCubit.state).thenReturn(mockVariablesState);

      mockBranchVariableValuesCubit = MockBranchVariableValuesCubit();
      when(() => mockBranchVariableValuesCubit.getVariableListItems(any())).thenReturn([]);

      mockBranchVariableValuesState = MockBranchVariableValuesState();
      when(() => mockBranchVariableValuesState.status).thenReturn(BranchVariableValuesStatus.loaded);
      when(() => mockBranchVariableValuesCubit.state).thenReturn(mockBranchVariableValuesState);

      registerFallbackValue(const BranchVariable.empty());
    });

    testWidgets('create and show variables', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(
              create: (context) => mockGitCalls,
            ),
            RepositoryProvider<VariablesHandler>(
              create: (context) => mockVariablesHandler,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<BranchVariablesCubit>(
                create: (context) => mockVariablesCubit,
              ),
              BlocProvider<BranchVariableValuesCubit>(
                create: (context) => mockBranchVariableValuesCubit,
              ),
            ],
            child: const BranchVariablesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BranchVariablesScreen), findsOneWidget);
      expect(find.byType(BranchVariableListItem), findsNWidgets(2));

      expect(find.text('Branch Variables'), findsOneWidget);

      expect(find.text('variable-1'), findsOneWidget);
      expect(find.text('Default Value: /home/user/src/project'), findsOneWidget);

      expect(find.text('variable-2'), findsOneWidget);
      expect(find.text('Default Value: /home/user/src/project-branch-a'), findsOneWidget);
    });

    testWidgets('add "cancel clicked"!', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(
              create: (context) => mockGitCalls,
            ),
            RepositoryProvider<VariablesHandler>(
              create: (context) => mockVariablesHandler,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<BranchVariablesCubit>(
                create: (context) => mockVariablesCubit,
              ),
              BlocProvider<BranchVariableValuesCubit>(
                create: (context) => mockBranchVariableValuesCubit,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: List.from(
                AppLocalizations.localizationsDelegates,
              )..add(FormBuilderLocalizations.delegate),
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => const BranchVariablesScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nameInput')), findsOneWidget);
      expect(find.byKey(const Key('valueInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => mockVariablesCubit.add(any<BranchVariable>()));
    });

    testWidgets('add "ok clicked", "All OK', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(
              create: (context) => mockGitCalls,
            ),
            RepositoryProvider<VariablesHandler>(
              create: (context) => mockVariablesHandler,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<BranchVariablesCubit>(
                create: (context) => mockVariablesCubit,
              ),
              BlocProvider<BranchVariableValuesCubit>(
                create: (context) => mockBranchVariableValuesCubit,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: List.from(
                AppLocalizations.localizationsDelegates,
              )..add(FormBuilderLocalizations.delegate),
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => const BranchVariablesScreen(),
            ),
          ),
        ),
      );

      when(() => mockVariablesHandler.suggestGitOrHomePath('pears')).thenReturn('pears');

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nameInput')), findsOneWidget);
      expect(find.byKey(const Key('valueInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('nameInput')), 'peaches');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('valueInput')), 'pears');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      final captured = verify(() => mockVariablesCubit.add(captureAny<BranchVariable>())).captured;
      final variable = captured.last as BranchVariable;

      expect(variable.uuid, isNotEmpty);
      expect(variable.name, equals('peaches'));
      expect(variable.defaultValue, equals('pears'));
    });

    testWidgets('add home directory used, variable substituted', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(
              create: (context) => mockGitCalls,
            ),
            RepositoryProvider<VariablesHandler>(
              create: (context) => mockVariablesHandler,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<BranchVariablesCubit>(
                create: (context) => mockVariablesCubit,
              ),
              BlocProvider<BranchVariableValuesCubit>(
                create: (context) => mockBranchVariableValuesCubit,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: List.from(
                AppLocalizations.localizationsDelegates,
              )..add(FormBuilderLocalizations.delegate),
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => const BranchVariablesScreen(),
            ),
          ),
        ),
      );

      when(() => mockVariablesHandler.suggestGitOrHomePath('/home/user/someplace/subdirectory')).thenReturn('{HOME}/subdirectory');

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nameInput')), findsOneWidget);
      expect(find.byKey(const Key('valueInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('nameInput')), 'peaches');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('valueInput')), '/home/user/someplace/subdirectory');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(find.text('Add Variable'), findsOneWidget);

      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);

      expect(find.text('The value could be shorted to use variables\n"/home/user/someplace/subdirectory"\nbecomes\n"{HOME}/subdirectory"?'), findsOneWidget);

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      final captured = verify(() => mockVariablesCubit.add(captureAny<BranchVariable>())).captured;
      final variable = captured.last as BranchVariable;

      expect(variable.uuid, isNotEmpty);
      expect(variable.name, equals('peaches'));
      expect(variable.defaultValue, equals('{HOME}/subdirectory'));
    });

    testWidgets('add home directory used, variable not substituted', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(
              create: (context) => mockGitCalls,
            ),
            RepositoryProvider<VariablesHandler>(
              create: (context) => mockVariablesHandler,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<BranchVariablesCubit>(
                create: (context) => mockVariablesCubit,
              ),
              BlocProvider<BranchVariableValuesCubit>(
                create: (context) => mockBranchVariableValuesCubit,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: List.from(
                AppLocalizations.localizationsDelegates,
              )..add(FormBuilderLocalizations.delegate),
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => const BranchVariablesScreen(),
            ),
          ),
        ),
      );

      when(() => mockVariablesHandler.suggestGitOrHomePath('/home/user/someplace/subdirectory')).thenReturn('{HOME}/subdirectory');

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nameInput')), findsOneWidget);
      expect(find.byKey(const Key('valueInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('nameInput')), 'peaches');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('valueInput')), '/home/user/someplace/subdirectory');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(find.text('Add Variable'), findsOneWidget);

      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);

      expect(find.text('The value could be shorted to use variables\n"/home/user/someplace/subdirectory"\nbecomes\n"{HOME}/subdirectory"?'), findsOneWidget);

      await tester.tap(find.text('No'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      final captured = verify(() => mockVariablesCubit.add(captureAny<BranchVariable>())).captured;
      final variable = captured.last as BranchVariable;

      expect(variable.uuid, isNotEmpty);
      expect(variable.name, equals('peaches'));
      expect(variable.defaultValue, equals('/home/user/someplace/subdirectory'));
    });

    testWidgets('test page route', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
            RepositoryProvider<GitCalls>(
              create: (context) => mockGitCalls,
            ),
            RepositoryProvider<VariablesHandler>(
              create: (context) => mockVariablesHandler,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<BranchVariablesCubit>(
                create: (context) => mockVariablesCubit,
              ),
              BlocProvider<BranchVariableValuesCubit>(
                create: (context) => mockBranchVariableValuesCubit,
              ),
            ],
            child: const TestApp(),
          ),
        ),
      );

      expect(find.byType(BranchVariablesScreen), findsNothing);

      await tester.tap(find.text('ClickMe'));
      await tester.pumpAndSettle();

      expect(find.byType(BranchVariablesScreen), findsOneWidget);
      expect(find.byType(BranchVariableListItem), findsNWidgets(2));
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
          case BranchVariablesScreen.routeName:
            return BranchVariablesScreen.pageRoute(context);
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
        onPressed: () => Navigator.of(context).pushNamed(BranchVariablesScreen.routeName),
        child: const Text('ClickMe'),
      );
}
