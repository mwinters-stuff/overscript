import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/global_variable/global_variable.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class GlobalVariablesScreen extends StatefulWidget {
  const GlobalVariablesScreen({Key? key}) : super(key: key);

  static const actionIcon = LineIcons.alternateList;
  static const routeName = '/globalVariables';
  static MaterialPageRoute pageRoute(BuildContext context) => MaterialPageRoute(
        builder: (BuildContext context) => const GlobalVariablesScreen(),
      );

  @override
  GlobalVariablesScreenState createState() => GlobalVariablesScreenState();
}

class GlobalVariablesScreenState extends State<GlobalVariablesScreen> {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<GlobalVariablesCubit, GlobalVariablesState>(
      builder: (context, state) => BlocBuilder<GlobalVariablesCubit, GlobalVariablesState>(
        builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(l10n.globalVariables),
            actions: [
              IconButton(
                key: const Key('AddIcon'),
                tooltip: l10n.addVariable,
                onPressed: () => addVariable(context),
                icon: const Icon(LineIcons.plusCircle),
              ),
            ],
          ),
          body: _listView(state.variables),
        ),
      ),
    );
  }

  void addVariable(BuildContext context) {
    final l10n = context.l10n;

    ValueEditDialog().showDialog(
      context: context,
      nameValue: '',
      initialValue: '',
      dialogTitle: l10n.addVariable,
      valueCaption: l10n.value,
      confirmCallback: (String name, String value) {
        context.read<GlobalVariablesCubit>().add(
              GlobalVariable(
                uuid: const Uuid().v1(),
                name: name,
                value: value,
              ),
            );
      },
    );
  }

  Widget _listView(List<GlobalVariable> variables) {
    return ListView.builder(
      itemCount: variables.length,
      itemBuilder: (context, index) => GlobalVariableListItem(
        variable: variables[index],
      ),
    );
  }
}
