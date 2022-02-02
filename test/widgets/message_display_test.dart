import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overscript/widgets/widgets.dart';

import '../helpers/helpers.dart';

void main() {
  group('MessageDisplay', () {
    testWidgets('show error message', (tester) async {
      await tester.pumpApp(const ShowMessageWidget());

      await tester.tap(find.text('ShowErrorMessage'));
      await tester.pumpAndSettle();

      expect(find.text('Error Title'), findsOneWidget);
      expect(find.text('Error Message'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(find.text('Error Title'), findsNothing);
    });

    testWidgets('show warning message', (tester) async {
      await tester.pumpApp(const ShowMessageWidget());

      await tester.tap(find.text('ShowWarningMessage'));
      await tester.pumpAndSettle();

      expect(find.text('Warning Title'), findsOneWidget);
      expect(find.text('Warning Message'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(find.text('Warning Title'), findsNothing);
    });

    testWidgets('show info message', (tester) async {
      await tester.pumpApp(const ShowMessageWidget());

      await tester.tap(find.text('ShowInfoMessage'));
      await tester.pumpAndSettle();

      expect(find.text('Info Title'), findsOneWidget);
      expect(find.text('Info Message'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(find.text('Info Title'), findsNothing);
    });

    testWidgets('show success message', (tester) async {
      await tester.pumpApp(const ShowMessageWidget());

      await tester.tap(find.text('ShowSuccessMessage'));
      await tester.pumpAndSettle();

      expect(find.text('Success Title'), findsOneWidget);
      expect(find.text('Success Message'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(find.text('Success Title'), findsNothing);
    });

    testWidgets('show confirm message click ok', (tester) async {
      await tester.pumpApp(const ShowMessageWidget());

      await tester.tap(find.text('ShowConfirmMessage'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Title'), findsOneWidget);
      expect(find.text('Confirm Message'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Result'), findsOneWidget);
      expect(find.text('Ok Pressed'), findsOneWidget);
    });

    testWidgets('show confirm message click cancel', (tester) async {
      await tester.pumpApp(const ShowMessageWidget());

      await tester.tap(find.text('ShowConfirmMessage'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Title'), findsOneWidget);
      expect(find.text('Confirm Message'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Result'), findsOneWidget);
      expect(find.text('Cancel Pressed'), findsOneWidget);
    });
  });
}

class ShowMessageWidget extends StatelessWidget {
  const ShowMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          MaterialButton(
            onPressed: () => showErrorMessage(
              context: context,
              title: 'Error Title',
              message: 'Error Message',
            ),
            child: const Text('ShowErrorMessage'),
          ),
          MaterialButton(
            onPressed: () => showWarningMessage(
              context: context,
              title: 'Warning Title',
              message: 'Warning Message',
            ),
            child: const Text('ShowWarningMessage'),
          ),
          MaterialButton(
            onPressed: () => showInfoMessage(
              context: context,
              title: 'Info Title',
              message: 'Info Message',
            ),
            child: const Text('ShowInfoMessage'),
          ),
          MaterialButton(
            onPressed: () => showSuccessMessage(
              context: context,
              title: 'Success Title',
              message: 'Success Message',
            ),
            child: const Text('ShowSuccessMessage'),
          ),
          MaterialButton(
            onPressed: () => showConfirmMessage(
              context: context,
              title: 'Confirm Title',
              message: 'Confirm Message',
              onCancelButton: () => showErrorMessage(
                context: context,
                title: 'Confirm Result',
                message: 'Cancel Pressed',
              ),
              onConfirmButton: () => showErrorMessage(
                context: context,
                title: 'Confirm Result',
                message: 'Ok Pressed',
              ),
            ),
            child: const Text('ShowConfirmMessage'),
          ),
        ],
      );
}
