import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:overscript/widgets/widgets.dart';

import '../helpers/helpers.dart';

// ignore: one_member_abstracts
abstract class ResultTest {
  void onResult(String value);
}

class MockResultTest extends Mock implements ResultTest {}

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
      final mockResult = MockResultTest();
      await tester.pumpApp(
        ShowMessageWidget(
          resultTest: mockResult,
        ),
      );

      await tester.tap(find.text('ShowConfirmMessage'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Title'), findsOneWidget);
      expect(find.text('Confirm Message'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      verify(() => mockResult.onResult('Ok Pressed')).called(1);
    });

    testWidgets('show confirm message click cancel', (tester) async {
      final mockResult = MockResultTest();
      await tester.pumpApp(
        ShowMessageWidget(
          resultTest: mockResult,
        ),
      );

      await tester.tap(find.text('ShowConfirmMessage'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Title'), findsOneWidget);
      expect(find.text('Confirm Message'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verify(() => mockResult.onResult('Cancel Pressed')).called(1);
    });

    testWidgets('show content dialog click ok', (tester) async {
      final mockResult = MockResultTest();
      await tester.pumpApp(
        ShowMessageWidget(
          resultTest: mockResult,
        ),
      );

      await tester.tap(find.text('ShowContentDialog'));
      await tester.pumpAndSettle();

      expect(find.text('Content Dialog'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      verify(() => mockResult.onResult('Ok Pressed')).called(1);
    });

    testWidgets('show content dialog click cancel', (tester) async {
      final mockResult = MockResultTest();
      await tester.pumpApp(
        ShowMessageWidget(
          resultTest: mockResult,
        ),
      );

      await tester.tap(find.text('ShowContentDialog'));
      await tester.pumpAndSettle();

      expect(find.text('Content Dialog'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verify(() => mockResult.onResult('Cancel Pressed')).called(1);
    });

    testWidgets('show input dialog click ok', (tester) async {
      final mockResult = MockResultTest();
      await tester.pumpApp(
        ShowMessageWidget(
          resultTest: mockResult,
        ),
      );

      await tester.tap(find.text('ShowInputDialog'));
      await tester.pumpAndSettle();

      expect(find.text('Input Dialog'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'New Value');
      await tester.pump();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      verify(() => mockResult.onResult('Ok Pressed New Value')).called(1);
    });

    testWidgets('show input dialog click cancel', (tester) async {
      final mockResult = MockResultTest();
      await tester.pumpApp(
        ShowMessageWidget(
          resultTest: mockResult,
        ),
      );

      await tester.tap(find.text('ShowInputDialog'));
      await tester.pumpAndSettle();

      expect(find.text('Input Dialog'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Ok'), findsNothing);
      verify(() => mockResult.onResult('Cancel Pressed')).called(1);
    });

    testWidgets('directory get ok', (tester) async {
      final mockResult = MockResultTest();
      final fakePlatformImplementation = FakeFileSelector();
      FileSelectorPlatform.instance = fakePlatformImplementation;

      fakePlatformImplementation
        ..setExpectations(initialDirectory: '/tmp', confirmButtonText: 'Select')
        ..setPathResponse('/home/user/source');

      await tester.pumpApp(
        ShowMessageWidget(
          resultTest: mockResult,
        ),
      );

      await tester.tap(find.text('ShowDirectoryDialog'));
      await tester.pumpAndSettle();

      verify(() => mockResult.onResult('Ok Pressed /home/user/source')).called(1);
    });

    testWidgets('file get ok', (tester) async {
      final mockResult = MockResultTest();
      final fakePlatformImplementation = FakeFileSelector();
      FileSelectorPlatform.instance = fakePlatformImplementation;

      fakePlatformImplementation
        ..setExpectations(initialDirectory: '/tmp', confirmButtonText: 'Select', suggestedName: 'afile.txt')
        ..setPathResponse('/tmp/another.file');
      await tester.pumpApp(
        ShowMessageWidget(
          resultTest: mockResult,
        ),
      );

      await tester.tap(find.text('ShowFileDialog'));
      await tester.pumpAndSettle();

      verify(() => mockResult.onResult('Ok Pressed /tmp/another.file')).called(1);
    });
  });
}

class ShowMessageWidget extends StatelessWidget {
  const ShowMessageWidget({
    Key? key,
    this.resultTest,
  }) : super(key: key);

  final ResultTest? resultTest;

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
              onCancelButton: () => resultTest!.onResult('Cancel Pressed'),
              onConfirmButton: () => resultTest!.onResult('Ok Pressed'),
            ),
            child: const Text('ShowConfirmMessage'),
          ),
          MaterialButton(
            onPressed: () => showContentDialog(
              context: context,
              title: 'Content Dialog',
              content: Checkbox(value: true, onChanged: (_) {}),
              onCancelButton: () => resultTest!.onResult('Cancel Pressed'),
              onConfirmButton: () => resultTest!.onResult('Ok Pressed'),
            ),
            child: const Text('ShowContentDialog'),
          ),
          MaterialButton(
            onPressed: () => showInputDialog(
              context: context,
              title: 'Input Dialog',
              label: 'Input Something',
              value: 'Initial Value',
              onCancelButton: () => resultTest!.onResult('Cancel Pressed'),
              onConfirmButton: (String newValue) => resultTest!.onResult('Ok Pressed $newValue'),
            ),
            child: const Text('ShowInputDialog'),
          ),
          MaterialButton(
            onPressed: () => getDirectory(
              context: context,
              initialDirectory: '/tmp',
            ).then((value) => resultTest!.onResult('Ok Pressed $value')),
            child: const Text('ShowDirectoryDialog'),
          ),
          MaterialButton(
            onPressed: () => getFile(
              context: context,
              currentFile: '/tmp/afile.txt',
            ).then((value) => resultTest!.onResult('Ok Pressed $value')),
            child: const Text('ShowFileDialog'),
          ),
        ],
      );
}
