import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/global_variable/global_variable.dart';

import '../../helpers/helpers.dart';

void main() {
  group('GlobalVariableListItem', () {
    late MockGlobalVariable mockVariable;
    late MockGlobalVariablesCubit mockGlobalVariablesCubit;
    late FakeFileSelector fakeFileSelectorImplementation;

    setUp(() {
      mockVariable = MockGlobalVariable();
      when(() => mockVariable.uuid).thenReturn('a-uuid');
      when(() => mockVariable.name).thenReturn('var1');
      when(() => mockVariable.value).thenReturn('/home/user/src/project');

      mockGlobalVariablesCubit = MockGlobalVariablesCubit();

      registerFallbackValue(const GlobalVariable.empty());
      fakeFileSelectorImplementation = FakeFileSelector();
      FileSelectorPlatform.instance = fakeFileSelectorImplementation;
    });

    testWidgets('renders GlobalVariableListItem', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GlobalVariablesCubit>(
              create: (context) => mockGlobalVariablesCubit,
            ),
          ],
          child: GlobalVariableListItem(
            variable: mockVariable,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlobalVariableListItem), findsOneWidget);
      expect(find.text('var1'), findsOneWidget);
      expect(find.text('/home/user/src/project'), findsOneWidget);
    });

    testWidgets('delete button, cancel', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GlobalVariablesCubit>(
              create: (context) => mockGlobalVariablesCubit,
            ),
          ],
          child: GlobalVariableListItem(
            variable: mockVariable,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlobalVariableListItem), findsOneWidget);

      await tester.tap(find.byKey(const Key('delete')));
      await tester.pumpAndSettle();

      expect(find.text('Delete Variable?'), findsOneWidget);
      expect(find.text('var1'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.press(find.text('Cancel'));

      await tester.pump();

      verifyNever(() => mockGlobalVariablesCubit.delete(mockVariable));
    });

    testWidgets('delete button, ok', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GlobalVariablesCubit>(
              create: (context) => mockGlobalVariablesCubit,
            ),
          ],
          child: GlobalVariableListItem(
            variable: mockVariable,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlobalVariableListItem), findsOneWidget);

      await tester.tap(find.byKey(const Key('delete')));
      await tester.pumpAndSettle();

      expect(find.text('Delete Variable?'), findsOneWidget);
      expect(find.text('var1'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Ok'));

      await tester.pump();

      verify(() => mockGlobalVariablesCubit.delete(mockVariable)).called(1);
    });

    testWidgets('choose directory', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GlobalVariablesCubit>(
              create: (context) => mockGlobalVariablesCubit,
            ),
          ],
          child: GlobalVariableListItem(
            variable: mockVariable,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlobalVariableListItem), findsOneWidget);
      expect(find.byKey(const Key('selectDirectoryButton')), findsOneWidget);

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '/home/user/src/project', confirmButtonText: 'Select')
        ..setPathResponse('/a/path');

      when(() => mockVariable.copyWithNewValue(newValue: '/a/path')).thenReturn(mockVariable);

      await tester.tap(find.byKey(const Key('selectDirectoryButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      verify(() => mockVariable.copyWithNewValue(newValue: '/a/path')).called(1);
      verify(() => mockGlobalVariablesCubit.updateValue(mockVariable)).called(1);
    });

    testWidgets('cancel choose directory', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GlobalVariablesCubit>(
              create: (context) => mockGlobalVariablesCubit,
            ),
          ],
          child: GlobalVariableListItem(
            variable: mockVariable,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlobalVariableListItem), findsOneWidget);
      expect(find.byKey(const Key('selectDirectoryButton')), findsOneWidget);

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '/home/user/src/project', confirmButtonText: 'Select')
        ..setPathResponse('');

      await tester.tap(find.byKey(const Key('selectDirectoryButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      verifyNever(() => mockVariable.copyWithNewValue(newValue: any<String>(named: 'newValue')));
      verifyNever(() => mockGlobalVariablesCubit.updateValue(any<GlobalVariable>()));
    });

    testWidgets('choose file', (tester) async {
      when(() => mockVariable.value).thenReturn('/tmp/afile.txt');

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GlobalVariablesCubit>(
              create: (context) => mockGlobalVariablesCubit,
            ),
          ],
          child: GlobalVariableListItem(
            variable: mockVariable,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GlobalVariableListItem), findsOneWidget);
      expect(find.byKey(const Key('selectFileButton')), findsOneWidget);

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '/tmp', confirmButtonText: 'Select', suggestedName: 'afile.txt')
        ..setPathResponse('/tmp/another.file');

      when(() => mockVariable.copyWithNewValue(newValue: '/tmp/another.file')).thenReturn(mockVariable);

      await tester.tap(find.byKey(const Key('selectFileButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      verify(() => mockVariable.copyWithNewValue(newValue: '/tmp/another.file')).called(1);
      verify(() => mockGlobalVariablesCubit.updateValue(mockVariable)).called(1);
    });

    testWidgets('cancel choose file', (tester) async {
      when(() => mockVariable.value).thenReturn('/tmp/afile.txt');
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GlobalVariablesCubit>(
              create: (context) => mockGlobalVariablesCubit,
            ),
          ],
          child: GlobalVariableListItem(
            variable: mockVariable,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlobalVariableListItem), findsOneWidget);
      expect(find.byKey(const Key('selectFileButton')), findsOneWidget);

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '/tmp', confirmButtonText: 'Select', suggestedName: 'afile.txt')
        ..setPathResponse('');
      await tester.tap(find.byKey(const Key('selectFileButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      verifyNever(() => mockVariable.copyWithNewValue(newValue: any<String>(named: 'newValue')));
      verifyNever(() => mockGlobalVariablesCubit.updateValue(any<GlobalVariable>()));
    });

    testWidgets('edit value ok', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GlobalVariablesCubit>(
              create: (context) => mockGlobalVariablesCubit,
            ),
          ],
          child: GlobalVariableListItem(
            variable: mockVariable,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlobalVariableListItem), findsOneWidget);
      expect(find.byKey(const Key('editValueButton')), findsOneWidget);
      await tester.tap(find.byKey(const Key('editValueButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Edit Variable Value'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      expect(find.text('/home/user/src/project'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      when(() => mockVariable.copyWithNewValue(newValue: 'something')).thenReturn(mockVariable);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'something');
      await tester.pump();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      verify(() => mockVariable.copyWithNewValue(newValue: 'something')).called(1);
      verify(() => mockGlobalVariablesCubit.updateValue(mockVariable)).called(1);
    });

    testWidgets('edit value cancel', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GlobalVariablesCubit>(
              create: (context) => mockGlobalVariablesCubit,
            ),
          ],
          child: GlobalVariableListItem(
            variable: mockVariable,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlobalVariableListItem), findsOneWidget);
      expect(find.byKey(const Key('editValueButton')), findsOneWidget);
      await tester.tap(find.byKey(const Key('editValueButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Edit Variable Value'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      expect(find.text('/home/user/src/project'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      when(() => mockVariable.copyWithNewValue(newValue: 'something')).thenReturn(mockVariable);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'something');
      await tester.pump();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => mockVariable.copyWithNewValue(newValue: 'something'));
      verifyNever(() => mockGlobalVariablesCubit.updateValue(mockVariable));
    });
  });
}
