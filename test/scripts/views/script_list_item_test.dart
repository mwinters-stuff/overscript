import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/scripts/scripts.dart';
import 'package:overscript/shells/shells.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ScriptListItem', () {
    late MockScriptsCubit mockScriptsCubit;
    late MockShellsCubit mockShellsCubit;

    setUp(() {
      mockScriptsCubit = MockScriptsCubit();
      mockShellsCubit = MockShellsCubit();
      initMocks();
      when(() => mockShellsCubit.get('sh-uuid-1')).thenReturn(mockShell1);

      registerFallbackValue(const Script.empty());
    });

    Future<void> pumpTheWidget(WidgetTester tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ScriptsCubit>(
              create: (context) => mockScriptsCubit,
            ),
            BlocProvider<ShellsCubit>(
              create: (context) => mockShellsCubit,
            ),
          ],
          child: Card(
            child: ScriptListItem(
              script: mockScript1,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders ScriptListItem', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(ScriptListItem), findsOneWidget);
      expect(find.text('script-1'), findsOneWidget);
      expect(find.text('command-1 arg-1 arg-2 arg-3'), findsOneWidget);
      expect(find.text('command-1'), findsNothing);

      await tester.tap(find.text('script-1'));
      await tester.pumpAndSettle();

      expect(find.text('command-1 arg-1 arg-2 arg-3'), findsNothing);

      expect(find.text('Shell'), findsOneWidget);
      expect(find.text('/usr/bin/bash'), findsOneWidget);

      expect(find.text('Command'), findsOneWidget);
      expect(find.text('command-1'), findsOneWidget);

      expect(find.text('Arguments'), findsOneWidget);
      expect(find.text('arg-1 arg-2 arg-3'), findsOneWidget);

      expect(find.text('Working Directory'), findsOneWidget);
      expect(find.text('/working/dir/1'), findsOneWidget);

      expect(find.text('Environment Variables'), findsOneWidget);
      expect(find.text('env-1 = env-value-1, env-2 = env-value-2'), findsOneWidget);

      await tester.tap(find.text('Arguments'));
      await tester.pumpAndSettle();

      expect(find.text('Arguments'), findsOneWidget);
      expect(find.text('arg-1 arg-2 arg-3'), findsNothing);

      expect(find.text('arg-1'), findsOneWidget);
      expect(find.text('arg-2'), findsOneWidget);
      expect(find.text('arg-3'), findsOneWidget);

      await tester.tap(find.text('Environment Variables'));
      await tester.pumpAndSettle();

      expect(find.text('Environment Variables'), findsOneWidget);
      expect(find.text('env-1 = env-value-1, env-2 = env-value-2'), findsNothing);

      expect(find.text('env-1 = env-value-1'), findsOneWidget);
      expect(find.text('env-2 = env-value-2'), findsOneWidget);
    });

    testWidgets('delete button, cancel', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(ScriptListItem), findsOneWidget);

      await tester.tap(find.byKey(const Key('delete')));
      await tester.pumpAndSettle();

      expect(find.text('Delete Script?'), findsOneWidget);
      expect(find.text('script-1'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.press(find.text('Cancel'));

      await tester.pump();

      verifyNever(() => mockScriptsCubit.delete(mockScript1));
    });

    testWidgets('delete button, ok', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(ScriptListItem), findsOneWidget);

      await tester.tap(find.byKey(const Key('delete')));
      await tester.pumpAndSettle();

      expect(find.text('Delete Script?'), findsOneWidget);
      expect(find.text('script-1'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Ok'));

      await tester.pumpAndSettle();

      verify(() => mockScriptsCubit.delete(mockScript1)).called(1);
    });

    // testWidgets('edit value ok', (tester) async {
    //   await pumpTheWidget(tester);

    //   expect(find.byType(ScriptListItem), findsOneWidget);
    //   expect(find.byKey(const Key('editValueButton')), findsOneWidget);
    //   await tester.tap(find.byKey(const Key('editValueButton')));
    //   await tester.pumpAndSettle(const Duration(milliseconds: 500));

    //   expect(find.text('Edit Arguments'), findsOneWidget);
    //   expect(find.text('Arguments'), findsOneWidget);
    //   expect(find.text('arg1 arg2'), findsNWidgets(1));
    //   expect(find.text('Cancel'), findsOneWidget);
    //   expect(find.text('Ok'), findsOneWidget);

    //   when(() => mockScript.copyWithNewArgs(newArgs: 'new-arg1 new-arg2')).thenReturn(mockScript);

    //   await tester.tap(find.byType(TextField));
    //   await tester.pump();
    //   await tester.enterText(find.byType(TextField), 'new-arg1 new-arg2');
    //   await tester.pump();

    //   await tester.tap(find.text('Ok'));
    //   await tester.pumpAndSettle();

    //   verify(() => mockScript.copyWithNewArgs(newArgs: 'new-arg1 new-arg2')).called(1);
    //   verify(() => mockScriptsCubit.updateArgs(mockScript)).called(1);
    // });

    // testWidgets('edit value cancel', (tester) async {
    //      await tester.pumpApp(
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<ShellsCubit>(
    //           create: (context) => mockShellsCubit,
    //         ),
    //       ],
    //       child: ScriptListItem(
    //         shell: mockShell,
    //       ),
    //     ),
    //   );
    //   await tester.pumpAndSettle();

    //   expect(find.byType(BranchVariableValueListItem), findsOneWidget);
    //   expect(find.byKey(const Key('editValueButton')), findsOneWidget);
    //   await tester.tap(find.byKey(const Key('editValueButton')));
    //   await tester.pumpAndSettle(const Duration(milliseconds: 500));

    //   expect(find.text('Edit Variable Value'), findsOneWidget);
    //   expect(find.text('Value'), findsOneWidget);
    //   expect(find.text('start value 1'), findsNWidgets(2));
    //   expect(find.text('Cancel'), findsOneWidget);
    //   expect(find.text('Ok'), findsOneWidget);

    //   when(() => mockBranchVariableValue1.copyWithNewValue(newValue: 'something')).thenReturn(mockBranchVariableValue1);

    //   await tester.tap(find.byType(TextField));
    //   await tester.pump();
    //   await tester.enterText(find.byType(TextField), 'something');
    //   await tester.pump();

    //   await tester.tap(find.text('Cancel'));
    //   await tester.pumpAndSettle();

    //   verifyNever(() => mockBranchVariableValue1.copyWithNewValue(newValue: 'something'));
    //   verifyNever(() => mockBranchVariableValuesCubit.updateValue(mockBranchVariableValue1));
    // });
  });
}
