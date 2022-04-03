import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/shells/shells.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShellListItem', () {
    late MockShellsCubit mockShellsCubit;

    setUp(() {
      mockShellsCubit = MockShellsCubit();
      initMocks();

      registerFallbackValue(const Shell.empty());
    });

    Future<void> pumpTheWidget(WidgetTester tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ShellsCubit>(
              create: (context) => mockShellsCubit,
            ),
          ],
          child: Card(
            child: ShellListItem(
              shell: mockShell1,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders ShellListItem', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(ShellListItem), findsOneWidget);
      expect(find.text('/usr/bin/bash'), findsOneWidget);
      expect(find.text('Arguments: arg1 arg2'), findsOneWidget);
    });

    testWidgets('delete button, cancel', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(ShellListItem), findsOneWidget);

      await tester.tap(find.byKey(const Key('delete')));
      await tester.pumpAndSettle();

      expect(find.text('Delete Shell?'), findsOneWidget);
      expect(find.text('/usr/bin/bash'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.press(find.text('Cancel'));

      await tester.pump();

      verifyNever(() => mockShellsCubit.delete(mockShell1));
    });

    testWidgets('delete button, ok', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(ShellListItem), findsOneWidget);

      await tester.tap(find.byKey(const Key('delete')));
      await tester.pumpAndSettle();

      expect(find.text('Delete Shell?'), findsOneWidget);
      expect(find.text('/usr/bin/bash'), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Ok'));

      await tester.pumpAndSettle();

      verify(() => mockShellsCubit.delete(mockShell1)).called(1);
    });

    testWidgets('edit value ok', (tester) async {
      await pumpTheWidget(tester);

      expect(find.byType(ShellListItem), findsOneWidget);
      expect(find.byKey(const Key('editValueButton')), findsOneWidget);
      await tester.tap(find.byKey(const Key('editValueButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Edit Arguments'), findsOneWidget);
      expect(find.text('Arguments'), findsOneWidget);
      expect(find.text('arg1 arg2'), findsNWidgets(1));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      when(() => mockShell1.copyWithNewArgs(newArgs: 'new-arg1 new-arg2')).thenReturn(mockShell1);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'new-arg1 new-arg2');
      await tester.pump();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      verify(() => mockShell1.copyWithNewArgs(newArgs: 'new-arg1 new-arg2')).called(1);
      verify(() => mockShellsCubit.updateArgs(mockShell1)).called(1);
    });

    // testWidgets('edit value cancel', (tester) async {
    //      await tester.pumpApp(
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<ShellsCubit>(
    //           create: (context) => mockShellsCubit,
    //         ),
    //       ],
    //       child: ShellListItem(
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
