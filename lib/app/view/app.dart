// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/branch_variable_value/views/variable_branch_value_list_item.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/theme/theme.dart';
import 'package:overscript/variable/variable.dart';
import 'package:overscript/widgets/main_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) => MaterialApp(
        theme: context.read<ThemeCubit>().getTheme(),
        localizationsDelegates: List.from(
          AppLocalizations.localizationsDelegates,
        )..add(FormBuilderLocalizations.delegate),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case BranchesScreen.routeName:
              return BranchesScreen.pageRoute(context);
            case VariablesScreen.routeName:
              return VariablesScreen.pageRoute(context);
          }
        },
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        home: buildWidget(context),
      ),
    );
  }

  Widget buildWidget(BuildContext context) {
    context.read<DataStoreRepository>().load('test.json').then(
      (value) {
        if (value) {
          context.read<GitBranchesCubit>().load();
          context.read<VariablesCubit>().load();
          context.read<BranchVariableValuesCubit>().load();
        }
      },
    );
    return const MainPage(title: 'Overscript');
  }
}
