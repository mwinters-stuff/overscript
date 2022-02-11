import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/gitbranch/views/branch_list_item.dart';
import 'package:overscript/variable/variable.dart';

import '../../helpers/helpers.dart';

class MockGitBranchesCubit extends MockCubit<GitBranchesState> implements GitBranchesCubit {}

class MockGitBranch extends Mock implements GitBranch {}

class MockBranchVariableValuesCubit extends MockCubit<BranchVariableValuesState> implements BranchVariableValuesCubit {}

class MockVariablesCubit extends MockCubit<VariablesState> implements VariablesCubit {}

void main() {
  group('BranchListItem', () {
    late MockGitBranch mockGitBranch;
    late MockGitBranchesCubit mockGitBranchesCubit;
    late MockBranchVariableValuesCubit mockBranchVariableValuesCubit;
    late MockVariablesCubit mockVariablesCubit;

    setUp(() {
      mockGitBranch = MockGitBranch();
      when(() => mockGitBranch.uuid).thenReturn('a-uuid');
      when(() => mockGitBranch.name).thenReturn('master');
      when(() => mockGitBranch.directory).thenReturn('/home/user/src/project');
      when(() => mockGitBranch.origin).thenReturn('git:someplace/bob');

      mockGitBranchesCubit = MockGitBranchesCubit();

      mockBranchVariableValuesCubit = MockBranchVariableValuesCubit();
      when(() => mockBranchVariableValuesCubit.getBranchListItems(any())).thenReturn(const [
        VariableBranchValueListItem(
          branchVariableValue: BranchVariableValue(
            uuid: 'uuid-1',
            branchUuid: 'branch-1',
            variableUuid: 'a-uuid-1',
            value: 'value 1',
          ),
        ),
        VariableBranchValueListItem(
          branchVariableValue: BranchVariableValue(
            uuid: 'uuid-2',
            branchUuid: 'branch-1',
            variableUuid: 'a-uuid-2',
            value: 'value 2',
          ),
        ),
      ]);

      mockVariablesCubit = MockVariablesCubit();
      when(() => mockVariablesCubit.getVariable('a-uuid-1')).thenReturn(
        const Variable(
          uuid: 'a-uuid-1',
          name: 'Variable 1',
          defaultValue: 'default1',
        ),
      );
      when(() => mockVariablesCubit.getVariable('a-uuid-2')).thenReturn(
        const Variable(
          uuid: 'a-uuid-2',
          name: 'Variable 2',
          defaultValue: 'default2',
        ),
      );
    });

    testWidgets('renders BranchListItem', (tester) async {
      await tester.pumpApp(
        BlocProvider<BranchVariableValuesCubit>(
          create: (_) => mockBranchVariableValuesCubit,
          child: BranchListItem(gitBranch: mockGitBranch),
        ),
      );
      expect(find.byType(BranchListItem), findsOneWidget);
      expect(find.text('master'), findsOneWidget);
      expect(find.text('/home/user/src/project'), findsOneWidget);
    });

    testWidgets('delete button, cancel', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GitBranchesCubit>(
              create: (context) => mockGitBranchesCubit,
            ),
            BlocProvider<VariablesCubit>(
              create: (context) => mockVariablesCubit,
            ),
            BlocProvider<BranchVariableValuesCubit>(
              create: (context) => mockBranchVariableValuesCubit,
            ),
          ],
          child: BranchListItem(
            gitBranch: mockGitBranch,
          ),
        ),
      );

      expect(find.byType(BranchListItem), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Delete Branch?'), findsOneWidget);
      expect(find.text('master'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.press(find.text('Cancel'));

      await tester.pump();

      verifyNever(() => mockGitBranchesCubit.delete(mockGitBranch));
    });

    testWidgets('delete button, ok', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GitBranchesCubit>(
              create: (context) => mockGitBranchesCubit,
            ),
            BlocProvider<VariablesCubit>(
              create: (context) => mockVariablesCubit,
            ),
            BlocProvider<BranchVariableValuesCubit>(
              create: (context) => mockBranchVariableValuesCubit,
            ),
          ],
          child: BranchListItem(
            gitBranch: mockGitBranch,
          ),
        ),
      );

      expect(find.byType(BranchListItem), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Delete Branch?'), findsOneWidget);
      expect(find.text('master'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Ok'));

      await tester.pump();

      verify(() => mockGitBranchesCubit.delete(mockGitBranch)).called(1);
    });

    testWidgets('click to expand and show variable values', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GitBranchesCubit>(
              create: (context) => mockGitBranchesCubit,
            ),
            BlocProvider<VariablesCubit>(
              create: (context) => mockVariablesCubit,
            ),
            BlocProvider<BranchVariableValuesCubit>(
              create: (context) => mockBranchVariableValuesCubit,
            ),
          ],
          child: BranchListItem(
            gitBranch: mockGitBranch,
          ),
        ),
      );

      expect(find.byType(ExpansionTile), findsOneWidget);
      expect(find.byType(VariableBranchValueListItem), findsNothing);

      await tester.tap(find.text('master'));
      await tester.pumpAndSettle();

      expect(find.byType(VariableBranchValueListItem), findsNWidgets(2));

      expect(find.text('Variable 1'), findsOneWidget);
      expect(find.text('Variable 2'), findsOneWidget);
      expect(find.text('value 1'), findsOneWidget);
      expect(find.text('value 2'), findsOneWidget);

      await tester.tap(find.text('master'));
      await tester.pumpAndSettle();

      expect(find.byType(VariableBranchValueListItem), findsNothing);
    });
  });
}
