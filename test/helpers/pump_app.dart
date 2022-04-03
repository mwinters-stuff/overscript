// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:overscript/l10n/l10n.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget? widget, {Map<String, WidgetBuilder> routes = const {}}) {
    binding.window.physicalSizeTestValue = const Size(2000, 800);
    binding.window.devicePixelRatioTestValue = 1.0;
    // resets the screen to its original size after the test end
    addTearDown(binding.window.clearPhysicalSizeTestValue);

    return pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          FormBuilderLocalizations.delegate,
        ],
        routes: routes,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }
}
