import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/widgets/widgets.dart';

typedef BranchListItemSelectedCallback = void Function(
    GitBranch script, bool selected);

class BranchListItem extends StatefulWidget {
  const BranchListItem(
      {Key? key, required this.gitBranch, this.selectedCallback})
      : super(key: key);

  final GitBranch gitBranch;
  final BranchListItemSelectedCallback? selectedCallback;

  @override
  BranchListItemState createState() => BranchListItemState();
}

class BranchListItemState extends State<BranchListItem> {
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
        color: _checked
            ? Theme.of(context).highlightColor
            : Theme.of(context).colorScheme.surface,
        child: InkWell(
          child: ListTile(
            title: Text(widget.gitBranch.name),
            subtitle: Text(widget.gitBranch.directory),
            trailing: IconButton(
              tooltip: l10n.deleteBranchTooltip,
              onPressed: () => showConfirmMessage(
                context: context,
                title: l10n.deleteBranchConfirmTitle,
                message: widget.gitBranch.name,
                onConfirmButton: () =>
                    context.read<GitBranchesCubit>().delete(widget.gitBranch),
              ),
              icon: const Icon(Icons.delete),
            ),
          ),
          onTap: () {
            widget.selectedCallback!(widget.gitBranch, !_checked);
            setState(() {
              _checked = !_checked;
            });
          },
        ),
      ),
    );
  }
}
