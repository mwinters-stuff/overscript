import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/scripts/scripts.dart';
import 'package:overscript/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class ScriptsScreen extends StatefulWidget {
  const ScriptsScreen({Key? key}) : super(key: key);

  static const actionIcon = LineIcons.code;
  static const routeName = '/scripts';
  static MaterialPageRoute pageRoute(BuildContext context) => MaterialPageRoute(
        builder: (BuildContext context) => const ScriptsScreen(),
      );

  @override
  ScriptsScreenState createState() => ScriptsScreenState();
}

class ScriptsScreenState extends State<ScriptsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    context.read<DataStoreRepository>().save('test.json');
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ScriptsCubit, ScriptsState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.scripts),
          actions: [
            IconButton(
              key: const Key('AddIcon'),
              tooltip: l10n.addScript,
              onPressed: () => addScript(context),
              icon: const Icon(LineIcons.plusCircle),
            ),
          ],
        ),
        body: _listView(state.scripts),
      ),
    );
  }

  void addScript(BuildContext context) {
    Navigator.of(context).pushNamed(ScriptEditScreen.routeName);
  }

  Widget _listView(List<Script> scripts) {
    return ListView.builder(
      itemCount: scripts.length,
      itemBuilder: (context, index) => ScriptListItem(
        script: scripts[index],
      ),
    );
  }
}
