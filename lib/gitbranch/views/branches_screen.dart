import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/gitbranch/views/branch_list_item.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({Key? key}) : super(key: key);

  static const actionIcon = LineIcons.git;
  static const routeName = '/branches';
  static MaterialPageRoute pageRoute(BuildContext context) => MaterialPageRoute(
        builder: (BuildContext context) => const BranchesScreen(),
      );

  @override
  BranchesScreenState createState() => BranchesScreenState();
}

class BranchesScreenState extends State<BranchesScreen> {
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
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<GitBranchesCubit, GitBranchesState>(
      builder: (context, state) => BlocBuilder<BranchVariableValuesCubit, BranchVariableValuesState>(
        builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(l10n.gitBranches),
            actions: [
              IconButton(
                key: const Key('AddIcon'),
                tooltip: l10n.addBranch,
                onPressed: () => addBranch(context),
                icon: const Icon(LineIcons.plusCircle),
              ),
            ],
          ),
          body: _listView(state.branches),
        ),
      ),
    );
  }

  void addBranch(BuildContext context) {
    final l10n = context.l10n;
    final gitCalls = context.read<GitCalls>();
    getDirectory(context: context, initialDirectory: '~').then((directory) {
      if (directory != null && directory.isNotEmpty) {
        gitCalls.getBranchName(directory).then((branchname) {
          gitCalls.getOriginRemote(directory).then((origin) {
            context.read<GitBranchesCubit>().add(
                  GitBranch(
                    uuid: const Uuid().v1(),
                    name: branchname,
                    directory: directory,
                    origin: origin,
                  ),
                );
          }).catchError((error) {
            showErrorMessage(
              context: context,
              title: l10n.addBranch,
              message: error! as String,
            );
          });
        }).catchError((error) {
          showErrorMessage(
            context: context,
            title: l10n.addBranch,
            message: '${l10n.gitDirectoryError}\n\n$error',
          );
        });
      }
    });
  }

  Widget _listView(List<GitBranch> branches) {
    return ListView.builder(
      itemCount: branches.length,
      itemBuilder: (context, index) => BranchListItem(
        gitBranch: branches[index],
      ),
    );
  }
}
