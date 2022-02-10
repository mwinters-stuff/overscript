import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/variable/variable.dart';

import '../../helpers/helpers.dart';

class MockBranchVariableValuesCubit extends MockCubit<BranchVariableValuesState> implements BranchVariableValuesCubit {}

class MockVariablesCubit extends MockCubit<VariablesState> implements VariablesCubit {}

class MockGitBranchCubit extends MockCubit<GitBranchesState> implements GitBranchesCubit {}

class MockVariable extends Mock implements Variable {}

void main() {
  group('VariableListItem', () {
    late MockVariable mockVariable;
    late MockVariablesCubit mockVariablesCubit;
    late MockBranchVariableValuesCubit mockBranchVariableValuesCubit;
    late MockGitBranchCubit mockGitBranchCubit;

    setUp(() {
      mockVariable = MockVariable();
      when(() => mockVariable.uuid).thenReturn('a-uuid');
      when(() => mockVariable.name).thenReturn('var1');
      when(() => mockVariable.defaultValue).thenReturn('/home/user/src/project');

      mockBranchVariableValuesCubit = MockBranchVariableValuesCubit();
      when(() => mockBranchVariableValuesCubit.getVariableListItems(any())).thenReturn(const [
        BranchVariableValueListItem(
          branchVariableValue: BranchVariableValue(
            uuid: 'uuid-1',
            branchUuid: 'branch-1',
            variableUuid: 'a-uuid',
            value: 'value 1',
          ),
        ),
        BranchVariableValueListItem(
          branchVariableValue: BranchVariableValue(
            uuid: 'uuid-2',
            branchUuid: 'branch-2',
            variableUuid: 'a-uuid',
            value: 'value 2',
          ),
        ),
      ]);

      mockGitBranchCubit = MockGitBranchCubit();
      when(() => mockGitBranchCubit.getBranch('branch-1')).thenReturn(
        const GitBranch(
          uuid: 'branch-1',
          name: 'Branch 1',
          directory: '',
          origin: '',
        ),
      );

      when(() => mockGitBranchCubit.getBranch('branch-2')).thenReturn(
        const GitBranch(
          uuid: 'branch-2',
          name: 'Branch 2',
          directory: '',
          origin: '',
        ),
      );

      mockVariablesCubit = MockVariablesCubit();
    });

    testWidgets('renders VariableListItem', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GitBranchesCubit>(
              create: (context) => mockGitBranchCubit,
            ),
            BlocProvider<VariablesCubit>(
              create: (context) => mockVariablesCubit,
            ),
            BlocProvider<BranchVariableValuesCubit>(
              create: (context) => mockBranchVariableValuesCubit,
            ),
          ],
          child: VariableListItem(
            variable: mockVariable,
          ),
        ),
      );

      expect(find.byType(VariableListItem), findsOneWidget);
      expect(find.text('var1'), findsOneWidget);
      expect(find.text('Default Value: /home/user/src/project'), findsOneWidget);
    });

    testWidgets('click to expand and show branch values', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GitBranchesCubit>(
              create: (context) => mockGitBranchCubit,
            ),
            BlocProvider<VariablesCubit>(
              create: (context) => mockVariablesCubit,
            ),
            BlocProvider<BranchVariableValuesCubit>(
              create: (context) => mockBranchVariableValuesCubit,
            ),
          ],
          child: VariableListItem(
            variable: mockVariable,
          ),
        ),
      );

      expect(find.byType(ExpansionTile), findsOneWidget);
      expect(find.byType(BranchVariableValueListItem), findsNothing);

      await tester.tap(find.text('var1'));
      await tester.pumpAndSettle();

      expect(find.byType(BranchVariableValueListItem), findsNWidgets(2));

      expect(find.text('Branch 1'), findsOneWidget);
      expect(find.text('Branch 2'), findsOneWidget);
      expect(find.text('value 1'), findsOneWidget);
      expect(find.text('value 2'), findsOneWidget);

      await tester.tap(find.text('var1'));
      await tester.pumpAndSettle();

      expect(find.byType(BranchVariableValueListItem), findsNothing);
    });

    testWidgets('delete button, cancel', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<VariablesCubit>(
              create: (context) => mockVariablesCubit,
            ),
            BlocProvider<BranchVariableValuesCubit>(
              create: (context) => mockBranchVariableValuesCubit,
            ),
          ],
          child: VariableListItem(
            variable: mockVariable,
          ),
        ),
      );
      expect(find.byType(VariableListItem), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Delete Variable?'), findsOneWidget);
      expect(find.text('var1'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.press(find.text('Cancel'));

      await tester.pump();

      verifyNever(() => mockVariablesCubit.delete(mockVariable));
    });

    testWidgets('delete button, ok', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<VariablesCubit>(
              create: (context) => mockVariablesCubit,
            ),
            BlocProvider<BranchVariableValuesCubit>(
              create: (context) => mockBranchVariableValuesCubit,
            ),
          ],
          child: VariableListItem(
            variable: mockVariable,
          ),
        ),
      );
      expect(find.byType(VariableListItem), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Delete Variable?'), findsOneWidget);
      expect(find.text('var1'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Ok'));

      await tester.pump();

      verify(() => mockVariablesCubit.delete(mockVariable)).called(1);
    });
  });
}
