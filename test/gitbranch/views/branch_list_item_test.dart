import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/gitbranch/views/branch_list_item.dart';

import '../../helpers/helpers.dart';

class MockGitBranchesCubit extends MockCubit<GitBranchesState> implements GitBranchesCubit {}

class MockGitBranch extends Mock implements GitBranch {}

void main() {
  group('BranchListItem', () {
    late MockGitBranch mockGitBranch;
    late MockGitBranchesCubit mockGitBranchesCubit;

    setUp(() {
      mockGitBranch = MockGitBranch();
      when(() => mockGitBranch.uuid).thenReturn('a-uuid');
      when(() => mockGitBranch.name).thenReturn('master');
      when(() => mockGitBranch.directory).thenReturn('/home/user/src/project');
      when(() => mockGitBranch.origin).thenReturn('git:someplace/bob');

      mockGitBranchesCubit = MockGitBranchesCubit();
    });

    testWidgets('renders BranchListItem', (tester) async {
      await tester.pumpApp(BranchListItem(gitBranch: mockGitBranch));
      expect(find.byType(BranchListItem), findsOneWidget);
      expect(find.text('master'), findsOneWidget);
      expect(find.text('/home/user/src/project'), findsOneWidget);
    });

    testWidgets('tap changes checked', (tester) async {
      var itemSelected = false;

      await tester.pumpApp(BranchListItem(
        gitBranch: mockGitBranch,
        selectedCallback: (script, selected) => itemSelected = selected,
      ));

      expect(find.byType(BranchListItem), findsOneWidget);

      await tester.tap(find.text('master'));
      expect(itemSelected, true);

      await tester.tap(find.text('master'));
      expect(itemSelected, false);

      // expect(find.text('/home/user/src/project'), findsOneWidget);
    });

    testWidgets('delete button, cancel', (tester) async {
      await tester.pumpApp(
        BlocProvider<GitBranchesCubit>(
          create: (_) => mockGitBranchesCubit,
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
        BlocProvider<GitBranchesCubit>(
          create: (_) => mockGitBranchesCubit,
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
  });
}
