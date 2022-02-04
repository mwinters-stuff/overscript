import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/variable/variable.dart';
import 'package:overscript/widgets/widgets.dart';

typedef VariableListItemSelectedCallback = void Function(Variable variable, bool selected);

class VariableListItem extends StatefulWidget {
  const VariableListItem({Key? key, required this.variable, this.selectedCallback}) : super(key: key);

  final Variable variable;
  final VariableListItemSelectedCallback? selectedCallback;

  @override
  VariableListItemState createState() => VariableListItemState();
}

class VariableListItemState extends State<VariableListItem> {
  bool _checked = false;

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
        color: _checked ? Theme.of(context).highlightColor : Theme.of(context).colorScheme.surface,
        child: InkWell(
          child: ListTile(
            title: Text(widget.variable.name),
            subtitle: Text('${l10n.defaultValueLabel}: ${widget.variable.defaultValue}'),
            trailing: IconButton(
              tooltip: l10n.deleteBranchTooltip,
              onPressed: () => showConfirmMessage(
                context: context,
                title: l10n.deleteVariableConfirmTitle,
                message: widget.variable.name,
                onConfirmButton: () => context.read<VariablesCubit>().delete(widget.variable),
              ),
              icon: const Icon(Icons.delete),
            ),
          ),
          onTap: () {
            widget.selectedCallback!(widget.variable, !_checked);
            setState(() {
              _checked = !_checked;
            });
          },
        ),
      ),
    );
  }
}
