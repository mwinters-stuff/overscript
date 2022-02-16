import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/gitbranch/gitbranch.dart';

import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/variable/variable.dart';
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
            icon: VariablesScreen.actionIcon,
            onPressed: () => Navigator.of(context).pushNamed(VariablesScreen.routeName),
          ),
          ActionButton(
            caption: l10n.globalVariables,
            icon: LineIcons.alternateList,
            onPressed: () => Navigator.of(context).pushNamed('/globalVariables'),
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
