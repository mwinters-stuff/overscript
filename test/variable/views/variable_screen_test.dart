import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/variable/variable.dart';

import '../../helpers/helpers.dart';

class MockDataStoreRepository extends Mock implements DataStoreRepository {}

class MockVariablesCubit extends MockCubit<VariablesState> implements VariablesCubit {}

class MockVariablesState extends Mock implements VariablesState {}

class MockVariable extends Mock implements Variable {}

class MockGitCalls extends Mock implements GitCalls {}

class MockBranchVariableValuesCubit extends MockCubit<BranchVariableValuesState> implements BranchVariableValuesCubit {}

void main() {
  group('VariablesScreen', () {
    late MockVariable mockVariable1;
    late MockVariable mockVariable2;
    late MockVariablesCubit mockVariablesCubit;
    late MockDataStoreRepository mockDataStoreRepository;
    late MockVariablesState mockVariablesState;
    late MockGitCalls mockGitCalls;
    late MockBranchVariableValuesCubit mockBranchVariableValuesCubit;

    setUp(() {
      mockDataStoreRepository = MockDataStoreRepository();
      mockVariablesState = MockVariablesState();
      mockVariablesCubit = MockVariablesCubit();
      mockGitCalls = MockGitCalls();

      mockVariable1 = MockVariable();
      when(() => mockVariable1.uuid).thenReturn('a-uuid-1');
      when(() => mockVariable1.name).thenReturn('variable-1');
      when(() => mockVariable1.defaultValue).thenReturn('/home/user/src/project');

      mockVariable2 = MockVariable();
      when(() => mockVariable2.uuid).thenReturn('a-uuid-2');
      when(() => mockVariable2.name).thenReturn('variable-2');
      when(() => mockVariable2.defaultValue).thenReturn('/home/user/src/project-branch-a');

      when(() => mockVariablesState.status).thenReturn(VariablesStatus.loaded);
      when(() => mockVariablesState.variables).thenReturn([mockVariable1, mockVariable2]);

      when(() => mockVariablesCubit.state).thenReturn(mockVariablesState);

      mockBranchVariableValuesCubit = MockBranchVariableValuesCubit();
      when(() => mockBranchVariableValuesCubit.getVariableListItems(any())).thenReturn([]);

      registerFallbackValue(const Variable.empty());
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
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<VariablesCubit>(
                create: (context) => mockVariablesCubit,
              ),
              BlocProvider<BranchVariableValuesCubit>(
                create: (context) => mockBranchVariableValuesCubit,
              ),
            ],
            child: const VariablesScreen(),
          ),
        ),
      );

      expect(find.byType(VariablesScreen), findsOneWidget);
      expect(find.byType(VariableListItem), findsNWidgets(2));

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
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<VariablesCubit>(
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
              builder: (context, child) => const VariablesScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nameInput')), findsOneWidget);
      expect(find.byKey(const Key('defaultValueInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => mockVariablesCubit.add(any<Variable>()));
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
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<VariablesCubit>(
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
              builder: (context, child) => const VariablesScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('AddIcon')), findsOneWidget);

      await tester.tap(find.byKey(const Key('AddIcon')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nameInput')), findsOneWidget);
      expect(find.byKey(const Key('defaultValueInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('nameInput')), 'peaches');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('defaultValueInput')), 'pears');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      final captured = verify(() => mockVariablesCubit.add(captureAny<Variable>())).captured;
      final variable = captured.last as Variable;

      expect(variable.uuid, isNotEmpty);
      expect(variable.name, equals('peaches'));
      expect(variable.defaultValue, equals('pears'));
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
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<VariablesCubit>(
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

      expect(find.byType(VariablesScreen), findsNothing);

      await tester.tap(find.text('ClickMe'));
      await tester.pumpAndSettle();

      expect(find.byType(VariablesScreen), findsOneWidget);
      expect(find.byType(VariableListItem), findsNWidgets(2));
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
          case VariablesScreen.routeName:
            return VariablesScreen.pageRoute(context);
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
        onPressed: () => Navigator.of(context).pushNamed(VariablesScreen.routeName),
        child: const Text('ClickMe'),
      );
}
