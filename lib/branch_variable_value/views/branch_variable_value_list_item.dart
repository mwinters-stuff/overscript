import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/gitbranch/cubit/gitbranches_cubit.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/variable/variable.dart';

import 'package:overscript/widgets/widgets.dart';

class BranchVariableValueListItem extends StatefulWidget {
  const BranchVariableValueListItem({Key? key, required this.branchVariableValue}) : super(key: key);

  final BranchVariableValue branchVariableValue;

  @override
  BranchVariableValueListItemState createState() => BranchVariableValueListItemState();
}

class BranchVariableValueListItemState extends State<BranchVariableValueListItem> {
  late BranchVariableValue currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.branchVariableValue;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text(context.read<GitBranchesCubit>().getBranch(currentValue.branchUuid)!.name), Text(currentValue.value)],
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
                  value: widget.branchVariableValue.value,
                  onConfirmButton: (newValue) {
                    setState(() => currentValue = currentValue.copyWithNewValue(newValue: newValue));
                    context.read<BranchVariableValuesCubit>().updateValue(currentValue);
                  },
                );
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              key: const Key('selectDirectoryButton'),
              tooltip: l10n.selectDirectory,
              onPressed: () {
                getDirectory(context: context, initialDirectory: currentValue.value).then(
                  (value) => setState(() {
                    if (value != null && value.isNotEmpty) {
                      currentValue = currentValue.copyWithNewValue(newValue: value);
                      context.read<BranchVariableValuesCubit>().updateValue(currentValue);
                    }
                  }),
                );
              },
              icon: const Icon(Icons.folder_rounded),
            ),
            IconButton(
              key: const Key('selectFileButton'),
              tooltip: l10n.selectFile,
              onPressed: () {
                getFile(context: context, currentFile: currentValue.value).then((value) {
                  if (value != null && value.isNotEmpty) {
                    currentValue = currentValue.copyWithNewValue(newValue: value);
                    context.read<BranchVariableValuesCubit>().updateValue(currentValue);
                  }
                });
              },
              icon: const Icon(Icons.file_present),
            ),
            IconButton(
              key: const Key('resetToDefaultButton'),
              tooltip: l10n.resetDefault,
              onPressed: () {
                final variable = context.read<VariablesCubit>().getVariable(currentValue.variableUuid);
                showConfirmMessage(
                  context: context,
                  title: l10n.resetDefaultValueQuestion,
                  message: '${l10n.ofStr} "${variable!.defaultValue}"?',
                  onConfirmButton: () {
                    setState(() {
                      currentValue = currentValue.copyWithNewValue(newValue: variable.defaultValue);
                      context.read<BranchVariableValuesCubit>().updateValue(currentValue);
                    });
                  },
                );
              },
              icon: const Icon(Icons.undo),
            ),
          ],
        ),
      ),
    );
  }
}
