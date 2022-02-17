import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/gitbranch/gitbranch.dart';

import '../../helpers/helpers.dart';

void main() {
  group('VariableBranchValueListItem', () {
    late MockGitBranch mockGitBranch1;
    late MockGitBranch mockGitBranch2;
    late MockBranchVariable mockVariable;
    late MockBranchVariableValue mockBranchVariableValue1;
    late MockBranchVariableValue mockBranchVariableValue2;

    late MockBranchVariableValueState mockBranchVariableValueState;
    late MockBranchVariableValuesCubit mockBranchVariableValuesCubit;

    late MockGitBranchesCubit mockGitBranchesCubit;
    late MockGitBranchesState mockGitBranchesState;
    late FakeFileSelector fakeFileSelectorImplementation;

    late MockBranchVariablesCubit mockBranchVariablesCubit;

    setUp(() {
      mockGitBranch1 = MockGitBranch();
      when(() => mockGitBranch1.uuid).thenReturn('a-uuid-1');
      when(() => mockGitBranch1.name).thenReturn('master');
      when(() => mockGitBranch1.directory).thenReturn('/home/user/src/project');
      when(() => mockGitBranch1.origin).thenReturn('git:someplace/bob');

      mockGitBranch2 = MockGitBranch();
      when(() => mockGitBranch2.uuid).thenReturn('a-uuid-2');
      when(() => mockGitBranch2.name).thenReturn('branch-one');
      when(() => mockGitBranch2.directory).thenReturn('/home/user/src/banch1');
      when(() => mockGitBranch2.origin).thenReturn('git:someplace/bob');

      mockVariable = MockBranchVariable();
      when(() => mockVariable.uuid).thenReturn('v-uuid-1');
      when(() => mockVariable.name).thenReturn('variable');
      when(() => mockVariable.defaultValue).thenReturn('default');

      mockBranchVariablesCubit = MockBranchVariablesCubit();
      when(() => mockBranchVariablesCubit.getVariable('v-uuid-1')).thenReturn(mockVariable);

      mockBranchVariableValue1 = MockBranchVariableValue();
      when(() => mockBranchVariableValue1.uuid).thenReturn('bvv-uuid-1');
      when(() => mockBranchVariableValue1.branchUuid).thenReturn('a-uuid-1');
      when(() => mockBranchVariableValue1.variableUuid).thenReturn('v-uuid-1');
      when(() => mockBranchVariableValue1.value).thenReturn('start value 1');
      // when(() => mockBranchVariableValue1.copyWithNewValue(newValue: newValue))

      mockBranchVariableValue2 = MockBranchVariableValue();
      when(() => mockBranchVariableValue2.uuid).thenReturn('bvv-uuid-2');
      when(() => mockBranchVariableValue2.branchUuid).thenReturn('a-uuid-2');
      when(() => mockBranchVariableValue2.variableUuid).thenReturn('v-uuid-1');
      when(() => mockBranchVariableValue2.value).thenReturn('start value 2');

      mockBranchVariableValueState = MockBranchVariableValueState();
      when(() => mockBranchVariableValueState.status).thenReturn(BranchVariableValuesStatus.loaded);
      when(() => mockBranchVariableValueState.getBranchVariableValue('bvv-uuid-1')).thenReturn(mockBranchVariableValue1);
      when(() => mockBranchVariableValueState.getBranchVariableValue('bvv-uuid-2')).thenReturn(mockBranchVariableValue2);

      mockBranchVariableValuesCubit = MockBranchVariableValuesCubit();
      when(() => mockBranchVariableValuesCubit.state).thenReturn(mockBranchVariableValueState);

      mockGitBranchesState = MockGitBranchesState();
      mockGitBranchesCubit = MockGitBranchesCubit();

      when(() => mockGitBranchesState.status).thenReturn(GitBranchesStatus.loaded);
      when(() => mockGitBranchesState.branches).thenReturn([mockGitBranch1, mockGitBranch2]);

      when(() => mockGitBranchesCubit.state).thenReturn(mockGitBranchesState);
      when(() => mockGitBranchesCubit.getBranch('a-uuid-1')).thenReturn(mockGitBranch1);
      when(() => mockGitBranchesCubit.getBranch('a-uuid-2')).thenReturn(mockGitBranch2);

      registerFallbackValue(const BranchVariableValue.empty());

      fakeFileSelectorImplementation = FakeFileSelector();
      FileSelectorPlatform.instance = fakeFileSelectorImplementation;
    });

    Future<void> pumpTheWidget(WidgetTester tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<BranchVariableValuesCubit>(
              create: (context) => mockBranchVariableValuesCubit,
            ),
            BlocProvider<GitBranchesCubit>(
              create: (context) => mockGitBranchesCubit,
            ),
            BlocProvider<BranchVariablesCubit>(
              create: (context) => mockBranchVariablesCubit,
            ),
          ],
          child: Card(
            child: VariableBranchValueListItem(
              branchVariableValue: mockBranchVariableValue1,
            ),
          ),
        ),
      );
    }

    testWidgets('renders VariableBranchValueListItem', (tester) async {
      await pumpTheWidget(tester);
      expect(find.byType(VariableBranchValueListItem), findsOneWidget);
      expect(find.text('variable'), findsOneWidget);
      expect(find.text('start value 1'), findsOneWidget);
      expect(find.byKey(const Key('resetToDefaultButton')), findsOneWidget);
      expect(find.byKey(const Key('selectFileButton')), findsOneWidget);
      expect(find.byKey(const Key('selectDirectoryButton')), findsOneWidget);
      expect(find.byKey(const Key('editValueButton')), findsOneWidget);
    });

    testWidgets('reset to default button, cancel', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(VariableBranchValueListItem), findsOneWidget);

      await tester.tap(find.byKey(const Key('resetToDefaultButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Reset to the default value?'), findsOneWidget);
      expect(find.text('of "default"?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => mockBranchVariableValue1.copyWithNewValue(newValue: any<String>(named: 'newValue')));
      verifyNever(() => mockBranchVariableValuesCubit.updateValue(any<BranchVariableValue>()));
    });

    testWidgets('reset to default button, ok', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(VariableBranchValueListItem), findsOneWidget);

      await tester.tap(find.byKey(const Key('resetToDefaultButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Reset to the default value?'), findsOneWidget);
      expect(find.text('of "default"?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      when(() => mockBranchVariableValue1.copyWithNewValue(newValue: 'default')).thenReturn(mockBranchVariableValue1);

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      verify(() => mockBranchVariableValue1.copyWithNewValue(newValue: 'default')).called(1);
      verify(() => mockBranchVariableValuesCubit.updateValue(mockBranchVariableValue1)).called(1);
    });

    testWidgets('choose directory', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(VariableBranchValueListItem), findsOneWidget);
      expect(find.byKey(const Key('selectDirectoryButton')), findsOneWidget);

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: 'start value 1', confirmButtonText: 'Select')
        ..setPathResponse('/a/path');

      when(() => mockBranchVariableValue1.copyWithNewValue(newValue: '/a/path')).thenReturn(mockBranchVariableValue1);

      await tester.tap(find.byKey(const Key('selectDirectoryButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      verify(() => mockBranchVariableValue1.copyWithNewValue(newValue: '/a/path')).called(1);
      verify(() => mockBranchVariableValuesCubit.updateValue(mockBranchVariableValue1)).called(1);
    });

    testWidgets('cancel choose directory', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(VariableBranchValueListItem), findsOneWidget);
      expect(find.byKey(const Key('selectDirectoryButton')), findsOneWidget);

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: 'start value 1', confirmButtonText: 'Select')
        ..setPathResponse('');

      await tester.tap(find.byKey(const Key('selectDirectoryButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      verifyNever(() => mockBranchVariableValue1.copyWithNewValue(newValue: any<String>(named: 'newValue')));
      verifyNever(() => mockBranchVariableValuesCubit.updateValue(any<BranchVariableValue>()));
    });

    testWidgets('choose file', (tester) async {
      when(() => mockBranchVariableValue1.value).thenReturn('/tmp/afile.txt');

      await pumpTheWidget(tester);

      expect(find.byType(VariableBranchValueListItem), findsOneWidget);
      expect(find.byKey(const Key('selectFileButton')), findsOneWidget);

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '/tmp', confirmButtonText: 'Select', suggestedName: 'afile.txt')
        ..setPathResponse('/tmp/another.file');

      when(() => mockBranchVariableValue1.copyWithNewValue(newValue: '/tmp/another.file')).thenReturn(mockBranchVariableValue1);

      await tester.tap(find.byKey(const Key('selectFileButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      verify(() => mockBranchVariableValue1.copyWithNewValue(newValue: '/tmp/another.file')).called(1);
      verify(() => mockBranchVariableValuesCubit.updateValue(mockBranchVariableValue1)).called(1);
    });

    testWidgets('cancel choose file', (tester) async {
      when(() => mockBranchVariableValue1.value).thenReturn('/tmp/afile.txt');
      await pumpTheWidget(tester);

      expect(find.byType(VariableBranchValueListItem), findsOneWidget);
      expect(find.byKey(const Key('selectFileButton')), findsOneWidget);

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '/tmp', confirmButtonText: 'Select', suggestedName: 'afile.txt')
        ..setPathResponse('');
      await tester.tap(find.byKey(const Key('selectFileButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      verifyNever(() => mockBranchVariableValue1.copyWithNewValue(newValue: any<String>(named: 'newValue')));
      verifyNever(() => mockBranchVariableValuesCubit.updateValue(any<BranchVariableValue>()));
    });

    testWidgets('edit value ok', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(VariableBranchValueListItem), findsOneWidget);
      expect(find.byKey(const Key('editValueButton')), findsOneWidget);
      await tester.tap(find.byKey(const Key('editValueButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Edit Variable Value'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      expect(find.text('start value 1'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      when(() => mockBranchVariableValue1.copyWithNewValue(newValue: 'something')).thenReturn(mockBranchVariableValue1);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'something');
      await tester.pump();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      verify(() => mockBranchVariableValue1.copyWithNewValue(newValue: 'something')).called(1);
      verify(() => mockBranchVariableValuesCubit.updateValue(mockBranchVariableValue1)).called(1);
    });

    testWidgets('edit value cancel', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(VariableBranchValueListItem), findsOneWidget);
      expect(find.byKey(const Key('editValueButton')), findsOneWidget);
      await tester.tap(find.byKey(const Key('editValueButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Edit Variable Value'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      expect(find.text('start value 1'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      when(() => mockBranchVariableValue1.copyWithNewValue(newValue: 'something')).thenReturn(mockBranchVariableValue1);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'something');
      await tester.pump();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => mockBranchVariableValue1.copyWithNewValue(newValue: 'something'));
      verifyNever(() => mockBranchVariableValuesCubit.updateValue(mockBranchVariableValue1));
    });
  });
}
