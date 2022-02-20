import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';

import '../../helpers/helpers.dart';

void main() {
  group('GlobalEnvironmentVariablesScreen', () {
    late MockGlobalEnvironmentVariable mockVariable1;
    late MockGlobalEnvironmentVariable mockVariable2;
    late MockGlobalEnvironmentVariablesCubit mockVariablesCubit;
    late MockGlobalEnvironmentVariablesState mockVariablesState;
    late MockDataStoreRepository mockDataStoreRepository;

    setUp(() {
      mockDataStoreRepository = MockDataStoreRepository();
      mockVariablesState = MockGlobalEnvironmentVariablesState();
      mockVariablesCubit = MockGlobalEnvironmentVariablesCubit();

      when(() => mockDataStoreRepository.save(any())).thenAnswer((_) => Future.value(true));
      when(() => mockDataStoreRepository.load(any())).thenAnswer((_) => Future.value(true));

      mockVariable1 = MockGlobalEnvironmentVariable();
      when(() => mockVariable1.uuid).thenReturn('a-uuid-1');
      when(() => mockVariable1.name).thenReturn('variable-1');
      when(() => mockVariable1.value).thenReturn('/home/user/src/project');

      mockVariable2 = MockGlobalEnvironmentVariable();
      when(() => mockVariable2.uuid).thenReturn('a-uuid-2');
      when(() => mockVariable2.name).thenReturn('variable-2');
      when(() => mockVariable2.value).thenReturn('/home/user/src/project-branch-a');

      when(() => mockVariablesState.status).thenReturn(GlobalEnvironmentVariablesStatus.loaded);
      when(() => mockVariablesState.variables).thenReturn([mockVariable1, mockVariable2]);

      when(() => mockVariablesCubit.state).thenReturn(mockVariablesState);

      registerFallbackValue(const GlobalEnvironmentVariable.empty());
    });

    testWidgets('create and show variables', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<GlobalEnvironmentVariablesCubit>(
                create: (context) => mockVariablesCubit,
              ),
            ],
            child: const GlobalEnvironmentVariablesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlobalEnvironmentVariablesScreen), findsOneWidget);
      expect(find.byType(GlobalEnvironmentVariableListItem), findsNWidgets(2));

      expect(find.text('Global Environment Variables'), findsOneWidget);

      expect(find.text('variable-1'), findsOneWidget);
      expect(find.text('/home/user/src/project'), findsOneWidget);

      expect(find.text('variable-2'), findsOneWidget);
      expect(find.text('/home/user/src/project-branch-a'), findsOneWidget);
    });

    testWidgets('add "cancel clicked"!', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<GlobalEnvironmentVariablesCubit>(
                create: (context) => mockVariablesCubit,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: List.from(
                AppLocalizations.localizationsDelegates,
              )..add(FormBuilderLocalizations.delegate),
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => const GlobalEnvironmentVariablesScreen(),
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

      verifyNever(() => mockVariablesCubit.add(any<GlobalEnvironmentVariable>()));
    });

    testWidgets('add "ok clicked", "All OK', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataStoreRepository>(
              create: (context) => mockDataStoreRepository,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<GlobalEnvironmentVariablesCubit>(
                create: (context) => mockVariablesCubit,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: List.from(
                AppLocalizations.localizationsDelegates,
              )..add(FormBuilderLocalizations.delegate),
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => const GlobalEnvironmentVariablesScreen(),
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

      await tester.enterText(find.byKey(const Key('nameInput')), 'peaches');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('valueInput')), 'pears');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      final captured = verify(() => mockVariablesCubit.add(captureAny<GlobalEnvironmentVariable>())).captured;
      final variable = captured.last as GlobalEnvironmentVariable;

      expect(variable.uuid, isNotEmpty);
      expect(variable.name, equals('peaches'));
      expect(variable.value, equals('pears'));
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
              BlocProvider<GlobalEnvironmentVariablesCubit>(
                create: (context) => mockVariablesCubit,
              ),
            ],
            child: const TestApp(),
          ),
        ),
      );

      expect(find.byType(GlobalEnvironmentVariablesScreen), findsNothing);

      await tester.tap(find.text('ClickMe'));
      await tester.pumpAndSettle();

      expect(find.byType(GlobalEnvironmentVariablesScreen), findsOneWidget);
      expect(find.byType(GlobalEnvironmentVariableListItem), findsNWidgets(2));
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
          case GlobalEnvironmentVariablesScreen.routeName:
            return GlobalEnvironmentVariablesScreen.pageRoute(context);
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
        onPressed: () => Navigator.of(context).pushNamed(GlobalEnvironmentVariablesScreen.routeName),
        child: const Text('ClickMe'),
      );
}
