import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/global_variable/global_variable.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/views/views.dart';

import '../helpers/helpers.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => const ConfigurationView(),
    GlobalVariablesScreen.routeName: (BuildContext context) => const Text('GlobalVariablesScreen'),
    BranchesScreen.routeName: (BuildContext context) => const Text('BranchesScreen'),
    BranchVariablesScreen.routeName: (BuildContext context) => const Text('BranchVariablesScreen'),
    '/scripts': (BuildContext context) => const Text('ScriptsScreen'),
  };
}

void main() {
  group('ConfigView ', () {
    final binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;

    setUp(() {
      binding.window.physicalSizeTestValue = const Size(1920, 1080);
      binding.window.devicePixelRatioTestValue = 1.0;
    });

    testWidgets('Create', (tester) async {
      await tester.pumpApp(
        const ConfigurationView(),
      );

      expect(find.text('Global Variables'), findsOneWidget);
      expect(find.byIcon(LineIcons.alternateList), findsOneWidget);

      expect(find.text('GIT Branches'), findsOneWidget);
      expect(find.byIcon(LineIcons.git), findsOneWidget);

      expect(find.text('Branch Variables'), findsOneWidget);
      expect(find.byIcon(LineIcons.list), findsOneWidget);

      expect(find.text('Scripts'), findsOneWidget);
      expect(find.byIcon(LineIcons.code), findsOneWidget);
    });

    testWidgets('Show Global Variables', (tester) async {
      await tester.pumpApp(
        MaterialApp(
          routes: routes(),
          localizationsDelegates: List.from(
            AppLocalizations.localizationsDelegates,
          ),
        ),
      );

      expect(find.text('Global Variables'), findsOneWidget);
      expect(find.byIcon(LineIcons.alternateList), findsOneWidget);

      await tester.tap(find.byIcon(LineIcons.alternateList));
      await tester.pumpAndSettle();

      expect(find.text('GlobalVariablesScreen'), findsOneWidget);
    });

    testWidgets('Show Branches', (tester) async {
      await tester.pumpApp(
        MaterialApp(
          routes: routes(),
          localizationsDelegates: List.from(
            AppLocalizations.localizationsDelegates,
          ),
        ),
      );

      expect(find.text('GIT Branches'), findsOneWidget);
      expect(find.byIcon(LineIcons.git), findsOneWidget);

      await tester.tap(find.byIcon(LineIcons.git));
      await tester.pumpAndSettle();

      expect(find.text('BranchesScreen'), findsOneWidget);
    });

    testWidgets('Show Variables', (tester) async {
      await tester.pumpApp(
        MaterialApp(
          routes: routes(),
          localizationsDelegates: List.from(
            AppLocalizations.localizationsDelegates,
          ),
        ),
      );

      expect(find.text('Branch Variables'), findsOneWidget);
      expect(find.byIcon(LineIcons.list), findsOneWidget);

      await tester.tap(find.byIcon(LineIcons.list));
      await tester.pumpAndSettle();

      expect(find.text('BranchVariablesScreen'), findsOneWidget);
    });

    testWidgets('Show Scripts', (tester) async {
      await tester.pumpApp(
        MaterialApp(
          routes: routes(),
          localizationsDelegates: List.from(
            AppLocalizations.localizationsDelegates,
          ),
        ),
      );

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
