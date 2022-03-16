import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';
import 'package:overscript/global_variable/global_variable.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/shells/shells.dart';
import 'package:overscript/views/views.dart';

import '../helpers/helpers.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => const ConfigurationView(),
    ShellsScreen.routeName: (BuildContext context) => const Text('ShellsScreen'),
    GlobalVariablesScreen.routeName: (BuildContext context) => const Text('GlobalVariablesScreen'),
    BranchesScreen.routeName: (BuildContext context) => const Text('BranchesScreen'),
    BranchVariablesScreen.routeName: (BuildContext context) => const Text('BranchVariablesScreen'),
    GlobalEnvironmentVariablesScreen.routeName: (BuildContext context) => const Text('GlobalEnvironmentVariablesScreen'),
    '/scripts': (BuildContext context) => const Text('ScriptsScreen'),
  };
}

void main() {
  group('ConfigurationView ', () {
    testWidgets('Create', (tester) async {
      await tester.pumpApp(
        const ConfigurationView(),
      );
      await tester.pumpAndSettle();
      expect(find.text('Shells'), findsOneWidget);
      expect(find.byIcon(LineIcons.terminal), findsOneWidget);

      expect(find.text('Global Variables'), findsOneWidget);
      expect(find.byIcon(LineIcons.alternateList), findsOneWidget);

      expect(find.text('GIT Branches'), findsOneWidget);
      expect(find.byIcon(LineIcons.git), findsOneWidget);

      expect(find.text('Branch Variables'), findsOneWidget);
      expect(find.byIcon(LineIcons.list), findsOneWidget);

      expect(find.text('Global Environment Variables'), findsOneWidget);
      expect(find.byIcon(Icons.view_list), findsOneWidget);

      expect(find.text('Scripts'), findsOneWidget);
      expect(find.byIcon(LineIcons.code), findsOneWidget);
    });

    testWidgets('Show Shells', (tester) async {
      await tester.pumpApp(
        null,
        routes: routes(),
      );
      await tester.pumpAndSettle();
      expect(find.text('Shells'), findsOneWidget);
      expect(find.byIcon(LineIcons.terminal), findsOneWidget);

      await tester.tap(find.byIcon(LineIcons.terminal));
      await tester.pumpAndSettle();

      expect(find.text('ShellsScreen'), findsOneWidget);
    });
    testWidgets('Show Global Variables', (tester) async {
      await tester.pumpApp(
        null,
        routes: routes(),
      );
      await tester.pumpAndSettle();
      expect(find.text('Global Variables'), findsOneWidget);
      expect(find.byIcon(LineIcons.alternateList), findsOneWidget);

      await tester.tap(find.byIcon(LineIcons.alternateList));
      await tester.pumpAndSettle();

      expect(find.text('GlobalVariablesScreen'), findsOneWidget);
    });

    testWidgets('Show Global Environment Variables', (tester) async {
      await tester.pumpApp(
        null,
        routes: routes(),
      );
      await tester.pumpAndSettle();
      expect(find.text('Global Environment Variables'), findsOneWidget);
      expect(find.byIcon(Icons.view_list), findsOneWidget);

      await tester.tap(find.byIcon(Icons.view_list));
      await tester.pumpAndSettle();

      expect(find.text('GlobalEnvironmentVariablesScreen'), findsOneWidget);
    });

    testWidgets('Show Branches', (tester) async {
      await tester.pumpApp(
        null,
        routes: routes(),
      );
      await tester.pumpAndSettle();
      expect(find.text('GIT Branches'), findsOneWidget);
      expect(find.byIcon(LineIcons.git), findsOneWidget);

      await tester.tap(find.byIcon(LineIcons.git));
      await tester.pumpAndSettle();

      expect(find.text('BranchesScreen'), findsOneWidget);
    });

    testWidgets('Show Variables', (tester) async {
      await tester.pumpApp(
        null,
        routes: routes(),
      );
      await tester.pumpAndSettle();
      expect(find.text('Branch Variables'), findsOneWidget);
      expect(find.byIcon(LineIcons.list), findsOneWidget);

      await tester.tap(find.byIcon(LineIcons.list));
      await tester.pumpAndSettle();

      expect(find.text('BranchVariablesScreen'), findsOneWidget);
    });

    testWidgets('Show Scripts', (tester) async {
      await tester.pumpApp(
        null,
        routes: routes(),
      );
      await tester.pumpAndSettle();
      expect(find.text('Scripts'), findsOneWidget);
      expect(find.byIcon(LineIcons.code), findsOneWidget);

      await tester.tap(find.byIcon(LineIcons.code));
      await tester.pumpAndSettle();

      expect(find.text('ScriptsScreen'), findsOneWidget);
    });

    testWidgets('test page route', (tester) async {
      await tester.pumpWidget(
        const TestApp(),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ConfigurationView), findsNothing);

      await tester.tap(find.text('ClickMe'));
      await tester.pumpAndSettle();

      expect(find.byType(ConfigurationView), findsOneWidget);

      expect(find.text('GIT Branches'), findsOneWidget);
      expect(find.text('Branch Variables'), findsOneWidget);
    });
  });
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case ConfigurationView.routeName:
            return ConfigurationView.pageRoute(context);
        }
        return null;
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const DummyHomeRoute(),
    );
  }
}

class DummyHomeRoute extends StatelessWidget {
  const DummyHomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: () => Navigator.of(context).pushNamed(ConfigurationView.routeName),
        child: const Text('ClickMe'),
      );
}
