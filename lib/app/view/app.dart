// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/global_environment_variable/global_environment_variable.dart';
import 'package:overscript/global_variable/global_variable.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/scripts/scripts.dart';
import 'package:overscript/shells/cubit/shells_cubit.dart';
import 'package:overscript/shells/views/shells_screen.dart';
import 'package:overscript/theme/theme.dart';
import 'package:overscript/views/views.dart';
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
            case BranchVariablesScreen.routeName:
              return BranchVariablesScreen.pageRoute(context);
            case ConfigurationView.routeName:
              return ConfigurationView.pageRoute(context);
            case GlobalVariablesScreen.routeName:
              return GlobalVariablesScreen.pageRoute(context);
            case GlobalEnvironmentVariablesScreen.routeName:
              return GlobalEnvironmentVariablesScreen.pageRoute(context);
            case ShellsScreen.routeName:
              return ShellsScreen.pageRoute(context);
            case ScriptsScreen.routeName:
              return ScriptsScreen.pageRoute(context);
            case ScriptEditScreen.routeName:
              return ScriptEditScreen.pageRoute(context, settings: settings);
          }
          return null;
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
          context.read<BranchVariablesCubit>().load();
          context.read<BranchVariableValuesCubit>().load();
          context.read<GlobalVariablesCubit>().load();
          context.read<GlobalEnvironmentVariablesCubit>().load();
          context.read<ShellsCubit>().load();
          context.read<ScriptsCubit>().load();
        }
      },
    );
    return const MainPage(title: 'Overscript');
  }
}
