import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/widgets/widgets.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';

import '../helpers/helpers.dart';

//import '../helpers/helpers.dart';

void main() {
  group('GlobalVariablesScreen', () {
    late FakeFileSelector fakeFileSelectorImplementation;

    setUp(() {
      fakeFileSelectorImplementation = FakeFileSelector();
      FileSelectorPlatform.instance = fakeFileSelectorImplementation;
    });

    testWidgets('input "cancel clicked"!', (tester) async {
      var cancelled = false;

      await tester.pumpApp(
        const Material(
          child: Center(
            child: Text('Go'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final BuildContext context = tester.element(find.text('Go'));

      ValueEditDialog().showDialog(
        context: context,
        nameValue: '',
        initialValue: '',
        dialogTitle: 'Input Dialog',
        valueCaption: 'Value',
        confirmCallback: (String name, String value) {},
        cancelCallback: () {
          cancelled = true;
        },
        // ignore: avoid_redundant_argument_values
        showDirFileButtons: true,
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nameInput')), findsOneWidget);
      expect(find.byKey(const Key('valueInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(cancelled, isTrue);
    });

    testWidgets('Initial values show', (tester) async {
      await tester.pumpApp(
        const Material(
          child: Center(
            child: Text('Go'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final BuildContext context = tester.element(find.text('Go'));

      ValueEditDialog().showDialog(
        context: context,
        nameValue: 'Initial Name',
        initialValue: 'Initial Value',
        dialogTitle: 'Input Dialog',
        valueCaption: 'Value',
        confirmCallback: (String name, String value) {},
        cancelCallback: () {},
        // ignore: avoid_redundant_argument_values
        showDirFileButtons: true,
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nameInput')), findsOneWidget);
      expect(find.byKey(const Key('valueInput')), findsOneWidget);

      expect(find.text('Input Dialog'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      expect(find.text('Initial Name'), findsOneWidget);
      expect(find.text('Initial Value'), findsOneWidget);

      expect(find.byKey(const Key('selectDirectoryButton')), findsOneWidget);
      expect(find.byKey(const Key('selectFileButton')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
    });

    testWidgets('Does not show file/directory buttons', (tester) async {
      await tester.pumpApp(
        const Material(
          child: Center(
            child: Text('Go'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final BuildContext context = tester.element(find.text('Go'));

      ValueEditDialog().showDialog(
        context: context,
        nameValue: 'Initial Name',
        initialValue: 'Initial Value',
        dialogTitle: 'Input Dialog',
        valueCaption: 'Value',
        confirmCallback: (String name, String value) {},
        cancelCallback: () {},
        showDirFileButtons: false,
      );

      await tester.pumpAndSettle();

      expect(find.text('Input Dialog'), findsOneWidget);

      expect(find.byKey(const Key('selectDirectoryButton')), findsNothing);
      expect(find.byKey(const Key('selectFileButton')), findsNothing);
    });

    testWidgets('input "ok clicked"', (tester) async {
      await tester.pumpApp(
        const Material(
          child: Center(
            child: Text('Go'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final BuildContext context = tester.element(find.text('Go'));

      var inputName = '';
      var inputValue = '';

      ValueEditDialog().showDialog(
        context: context,
        nameValue: '',
        initialValue: '',
        dialogTitle: 'Input Dialog',
        valueCaption: 'Value',
        confirmCallback: (String name, String value) {
          inputName = name;
          inputValue = value;
        },
        cancelCallback: () {},
        // ignore: avoid_redundant_argument_values
        showDirFileButtons: true,
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nameInput')), findsOneWidget);
      expect(find.byKey(const Key('valueInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('nameInput')), 'peaches');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('valueInput')), 'pears');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(inputName, equals('peaches'));
      expect(inputValue, equals('pears'));
    });

    testWidgets('input using directory selector', (tester) async {
      await tester.pumpApp(
        const Material(
          child: Center(
            child: Text('Go'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final BuildContext context = tester.element(find.text('Go'));

      var inputName = '';
      var inputValue = '';

      ValueEditDialog().showDialog(
        context: context,
        nameValue: '',
        initialValue: '',
        dialogTitle: 'Input Dialog',
        valueCaption: 'Value',
        confirmCallback: (String name, String value) {
          inputName = name;
          inputValue = value;
        },
        cancelCallback: () {},
        // ignore: avoid_redundant_argument_values
        showDirFileButtons: true,
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nameInput')), findsOneWidget);
      expect(find.byKey(const Key('valueInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('nameInput')), 'peaches');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('valueInput')), '/home/bob');
      await tester.pumpAndSettle();

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '/home/bob', confirmButtonText: 'Select')
        ..setPathResponse('/a/path');

      await tester.tap(find.byKey(const Key('valueInput')));

      expect(find.byKey(const Key('selectDirectoryButton')), findsOneWidget);
      await tester.tap(find.byKey(const Key('selectDirectoryButton')));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(inputName, equals('peaches'));
      expect(inputValue, equals('/a/path'));
    });

    testWidgets('input using file selector', (tester) async {
      await tester.pumpApp(
        const Material(
          child: Center(
            child: Text('Go'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final BuildContext context = tester.element(find.text('Go'));

      var inputName = '';
      var inputValue = '';

      ValueEditDialog().showDialog(
        context: context,
        nameValue: '',
        initialValue: '',
        dialogTitle: 'Input Dialog',
        valueCaption: 'Value',
        confirmCallback: (String name, String value) {
          inputName = name;
          inputValue = value;
        },
        cancelCallback: () {},
        // ignore: avoid_redundant_argument_values
        showDirFileButtons: true,
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nameInput')), findsOneWidget);
      expect(find.byKey(const Key('valueInput')), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('nameInput')), 'peaches');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('valueInput')), '/home/bob/a.file');
      await tester.pumpAndSettle();

      fakeFileSelectorImplementation
        ..setExpectations(initialDirectory: '/home/bob', confirmButtonText: 'Select', suggestedName: 'a.file')
        ..setPathResponse('/tmp/another.file')
        ..setFileResponse([XFile('/tmp/another.file')]);

      await tester.tap(find.byKey(const Key('valueInput')));

      expect(find.byKey(const Key('selectFileButton')), findsOneWidget);
      await tester.tap(find.byKey(const Key('selectFileButton')));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(inputName, equals('peaches'));
      expect(inputValue, equals('/tmp/another.file'));
    });
  });
}
