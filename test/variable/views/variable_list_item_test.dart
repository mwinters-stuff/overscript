import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/variable/variable.dart';

import '../../helpers/helpers.dart';

class MockVariablesCubit extends MockCubit<VariablesState> implements VariablesCubit {}

class MockVariable extends Mock implements Variable {}

void main() {
  group('VariableListItem', () {
    late MockVariable mockVariable;
    late MockVariablesCubit mockVariablesCubit;

    setUp(() {
      mockVariable = MockVariable();
      when(() => mockVariable.uuid).thenReturn('a-uuid');
      when(() => mockVariable.name).thenReturn('var1');
      when(() => mockVariable.defaultValue).thenReturn('/home/user/src/project');

      mockVariablesCubit = MockVariablesCubit();
    });

    testWidgets('renders VariableListItem', (tester) async {
      await tester.pumpApp(VariableListItem(variable: mockVariable));
      expect(find.byType(VariableListItem), findsOneWidget);
      expect(find.text('var1'), findsOneWidget);
      expect(find.text('Default Value: /home/user/src/project'), findsOneWidget);
    });

    testWidgets('tap changes checked', (tester) async {
      var itemSelected = false;

      await tester.pumpApp(
        VariableListItem(
          variable: mockVariable,
          selectedCallback: (script, selected) => itemSelected = selected,
        ),
      );

      expect(find.byType(VariableListItem), findsOneWidget);

      await tester.tap(find.text('var1'));
      expect(itemSelected, true);

      await tester.tap(find.text('var1'));
      expect(itemSelected, false);

      // expect(find.text('/home/user/src/project'), findsOneWidget);
    });

    testWidgets('delete button, cancel', (tester) async {
      await tester.pumpApp(
        BlocProvider<VariablesCubit>(
          create: (_) => mockVariablesCubit,
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
        BlocProvider<VariablesCubit>(
          create: (_) => mockVariablesCubit,
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
