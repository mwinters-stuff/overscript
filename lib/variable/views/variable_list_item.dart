import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/variable/variable.dart';
import 'package:overscript/widgets/widgets.dart';

class VariableListItem extends StatefulWidget {
  const VariableListItem({Key? key, required this.variable}) : super(key: key);

  final Variable variable;

  @override
  VariableListItemState createState() => VariableListItemState();
}

class VariableListItemState extends State<VariableListItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(widget.variable.name),
          subtitle: Text('${l10n.defaultValue}: ${widget.variable.defaultValue}'),
          trailing: IconButton(
            tooltip: l10n.deleteVariable,
            onPressed: () => showConfirmMessage(
              context: context,
              title: l10n.deleteVariableQuestion,
              message: widget.variable.name,
              onConfirmButton: () => context.read<VariablesCubit>().delete(widget.variable),
            ),
            icon: const Icon(Icons.delete),
          ),
          children: context.read<BranchVariableValuesCubit>().getVariableListItems(widget.variable.uuid),
        ),
      ),
    );
  }
}
