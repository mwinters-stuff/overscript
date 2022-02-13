import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/widgets/widgets.dart';

class BranchListItem extends StatefulWidget {
  const BranchListItem({Key? key, required this.gitBranch}) : super(key: key);

  final GitBranch gitBranch;

  @override
  BranchListItemState createState() => BranchListItemState();
}

class BranchListItemState extends State<BranchListItem> {
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
                  widget.gitBranch.name,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Text(widget.gitBranch.directory, textAlign: TextAlign.start),
              ),
            ],
          ),
          trailing: IconButton(
            key: const Key('delete'),
            tooltip: l10n.deleteBranch,
            onPressed: () => showConfirmMessage(
              context: context,
              title: l10n.deleteBranchQuestion,
              message: widget.gitBranch.name,
              onConfirmButton: () => context.read<GitBranchesCubit>().delete(widget.gitBranch),
            ),
            icon: const Icon(LineIcons.alternateTrash),
          ),
          children: context.read<BranchVariableValuesCubit>().getBranchListItems(widget.gitBranch.uuid),
        ),
      ),
    );
  }
}
