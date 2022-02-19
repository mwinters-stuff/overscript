import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/global_variable/global_variable.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/widgets/widgets.dart';

class GlobalVariableListItem extends StatefulWidget {
  const GlobalVariableListItem({Key? key, required this.variable}) : super(key: key);

  final GlobalVariable variable;

  @override
  GlobalVariableListItemState createState() => GlobalVariableListItemState();
}

class GlobalVariableListItemState extends State<GlobalVariableListItem> {
  late GlobalVariable currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.variable;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: ListTile(
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
                child: Text(widget.variable.value, textAlign: TextAlign.start),
              ),
            ],
          ),
          trailing: Wrap(
            spacing: 8,
            children: [
              IconButton(
                key: const Key('editValueButton'),
                tooltip: l10n.editVariable,
                onPressed: () {
                  showInputDialog(
                    context: context,
                    title: l10n.editVariableValue,
                    label: l10n.value,
                    value: widget.variable.value,
                    onConfirmButton: (newValue) {
                      setState(() => currentValue = currentValue.copyWithNewValue(newValue: newValue));
                      context.read<GlobalVariablesCubit>().updateValue(currentValue);
                    },
                  );
                },
                icon: const Icon(LineIcons.edit),
              ),
              IconButton(
                key: const Key('selectDirectoryButton'),
                tooltip: l10n.selectDirectory,
                onPressed: () {
                  getDirectory(context: context, initialDirectory: currentValue.value).then(
                    (value) => setState(() {
                      if (value != null && value.isNotEmpty) {
                        currentValue = currentValue.copyWithNewValue(newValue: value);
                        context.read<GlobalVariablesCubit>().updateValue(currentValue);
                      }
                    }),
                  );
                },
                icon: const Icon(LineIcons.folder),
              ),
              IconButton(
                key: const Key('selectFileButton'),
                tooltip: l10n.selectFile,
                onPressed: () {
                  getFile(context: context, currentFile: currentValue.value).then((value) {
                    if (value != null && value.isNotEmpty) {
                      currentValue = currentValue.copyWithNewValue(newValue: value);
                      context.read<GlobalVariablesCubit>().updateValue(currentValue);
                    }
                  });
                },
                icon: const Icon(LineIcons.file),
              ),
              IconButton(
                key: const Key('delete'),
                tooltip: l10n.deleteVariable,
                onPressed: () => showConfirmMessage(
                  context: context,
                  title: l10n.deleteVariableQuestion,
                  message: widget.variable.name,
                  onConfirmButton: () => context.read<GlobalVariablesCubit>().delete(widget.variable),
                ),
                icon: const Icon(LineIcons.alternateTrash),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
