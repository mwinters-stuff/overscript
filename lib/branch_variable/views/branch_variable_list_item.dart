import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/widgets/widgets.dart';

class BranchVariableListItem extends StatefulWidget {
  const BranchVariableListItem({Key? key, required this.variable}) : super(key: key);

  final BranchVariable variable;

  @override
  BranchVariableListItemState createState() => BranchVariableListItemState();
}

class BranchVariableListItemState extends State<BranchVariableListItem> {
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  widget.variable.name,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Text('${l10n.defaultValue}: ${widget.variable.defaultValue}', textAlign: TextAlign.start),
              ),
            ],
          ),
          trailing: IconButton(
            key: const Key('delete'),
            tooltip: l10n.deleteVariable,
            onPressed: () => showConfirmMessage(
              context: context,
              title: l10n.deleteVariableQuestion,
              message: widget.variable.name,
              onConfirmButton: () => context.read<BranchVariablesCubit>().delete(widget.variable),
            ),
            icon: const Icon(LineIcons.alternateTrash),
          ),
          children: context.read<BranchVariableValuesCubit>().getVariableListItems(widget.variable.uuid),
        ),
      ),
    );
  }
}
