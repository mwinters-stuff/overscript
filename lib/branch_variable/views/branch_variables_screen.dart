import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:format/format.dart';

class BranchVariablesScreen extends StatefulWidget {
  const BranchVariablesScreen({Key? key}) : super(key: key);

  static const actionIcon = LineIcons.list;
  static const routeName = '/variables';
  static MaterialPageRoute pageRoute(BuildContext context) => MaterialPageRoute(
        builder: (BuildContext context) => const BranchVariablesScreen(),
      );

  @override
  BranchVariablesScreenState createState() => BranchVariablesScreenState();
}

class BranchVariablesScreenState extends State<BranchVariablesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    // context.read<VariablesCubit>().save();
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
    return BlocBuilder<BranchVariablesCubit, BranchVariablesState>(
      builder: (context, state) => BlocBuilder<BranchVariableValuesCubit, BranchVariableValuesState>(
        builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(l10n.branchVariables),
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

  void _addVariable(String name, String value) {
    context.read<BranchVariablesCubit>().add(
          BranchVariable(
            uuid: const Uuid().v1(),
            name: name,
            defaultValue: value,
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
      valueCaption: l10n.defaultValue,
      confirmCallback: (String name, String value) {
        final suggestedValue = context.read<VariablesHandler>().suggestGitOrHomePath(value);
        if (suggestedValue != value) {
          alertDialog(
            context,
            l10n.addVariable,
            format(l10n.confirmVariableChange, value, suggestedValue),
            positiveButtonText: l10n.yes,
            negativeButtonText: l10n.no,
            hideNeutralButton: true,
            positiveButtonAction: () {
              _addVariable(name, suggestedValue);
            },
            negativeButtonAction: () {
              _addVariable(name, value);
            },
          );
        } else {
          _addVariable(name, value);
        }
      },
    );
  }

  Widget _listView(List<BranchVariable> branches) {
    return ListView.builder(
      itemCount: branches.length,
      itemBuilder: (context, index) => BranchVariableListItem(
        variable: branches[index],
      ),
    );
  }
}
