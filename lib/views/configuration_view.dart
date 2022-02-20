import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/git_branch/git_branch.dart';
import 'package:overscript/global_variable/global_variable.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/widgets/action_button.dart';

class ConfigurationView extends StatelessWidget {
  const ConfigurationView({Key? key}) : super(key: key);

  static const actionIcon = LineIcons.horizontalSliders;
  static const routeName = '/configuration';

  static MaterialPageRoute pageRoute(BuildContext context) => MaterialPageRoute(
        builder: (BuildContext context) => const ConfigurationView(),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.configuration),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ActionButton(
            caption: l10n.gitBranches,
            icon: BranchesScreen.actionIcon,
            onPressed: () => Navigator.of(context).pushNamed(BranchesScreen.routeName),
          ),
          ActionButton(
            caption: l10n.branchVariables,
            icon: BranchVariablesScreen.actionIcon,
            onPressed: () => Navigator.of(context).pushNamed(BranchVariablesScreen.routeName),
          ),
          ActionButton(
            caption: l10n.globalVariables,
            icon: GlobalVariablesScreen.actionIcon,
            onPressed: () => Navigator.of(context).pushNamed(GlobalVariablesScreen.routeName),
          ),
          ActionButton(
            caption: l10n.scripts,
            icon: LineIcons.code,
            onPressed: () => Navigator.of(context).pushNamed('/scripts'),
          ),
        ],
      ),
    );
  }
}
