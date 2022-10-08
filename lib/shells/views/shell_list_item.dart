import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/shells/cubit/shell.dart';
import 'package:overscript/shells/cubit/shells_cubit.dart';
import 'package:overscript/widgets/widgets.dart';

class ShellListItem extends StatefulWidget {
  const ShellListItem({Key? key, required this.shell}) : super(key: key);

  final Shell shell;

  @override
  ShellListItemState createState() => ShellListItemState();
}

class ShellListItemState extends State<ShellListItem> {
  late Shell currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.shell;
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
                  currentValue.command,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Text('${l10n.arguments}: ${currentValue.args.join(' ')}', textAlign: TextAlign.start),
              ),
            ],
          ),
          trailing: Wrap(
            spacing: 8,
            children: [
              IconButton(
                key: const Key('editValueButton'),
                tooltip: l10n.editShell,
                onPressed: () {
                  showInputDialog(
                    context: context,
                    title: l10n.editArguments,
                    label: l10n.arguments,
                    value: currentValue.args.join(' '),
                    onConfirmButton: (newValue) {
                      setState(() => currentValue = currentValue.copyWithNewArgs(newArgs: newValue));
                      context.read<ShellsCubit>().updateArgs(currentValue);
                    },
                  );
                },
                icon: const Icon(LineIcons.edit),
              ),
              IconButton(
                key: const Key('delete'),
                tooltip: l10n.deleteShell,
                onPressed: () => showConfirmMessage(
                  context: context,
                  title: l10n.deleteShellQuestion,
                  message: widget.shell.command,
                  onConfirmButton: () => context.read<ShellsCubit>().delete(currentValue),
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
