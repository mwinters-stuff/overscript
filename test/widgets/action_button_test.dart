import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:line_icons/line_icons.dart';

import 'package:overscript/widgets/widgets.dart';

import '../helpers/helpers.dart';

void main() {
  group('ActionButton', () {
    testWidgets('test', (tester) async {
      var pressed = 0;
      await tester.pumpApp(
        Card(
          child: ActionButton(
            caption: 'Test Button',
            icon: LineIcons.accessibleIcon,
            onPressed: () => pressed++,
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byIcon(LineIcons.accessibleIcon), findsOneWidget);

      await tester.tap(find.byIcon(LineIcons.accessibleIcon));
      await tester.pumpAndSettle();

      expect(pressed, equals(1));
    });
  });
}
