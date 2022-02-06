import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/gitbranch/views/branch_list_item.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({Key? key}) : super(key: key);

  static const routeName = '/branches';
  static MaterialPageRoute pageRoute(BuildContext context) => MaterialPageRoute(
        builder: (BuildContext context) => const BranchesScreen(),
      );

  @override
  BranchesScreenState createState() => BranchesScreenState();
}

class BranchesScreenState extends State<BranchesScreen> {
  final List<GitBranch> _selected = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    context.read<GitBranchesCubit>().save(context.read<DataStoreRepository>());
    context.read<DataStoreRepository>().save('test.json');
    super.deactivate();
  }

  String _branchesNameList(List<GitBranch> branches) {
    final sb = StringBuffer();
    for (final script in branches) {
      sb.writeln(script.name);
    }
    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<GitBranchesCubit, GitBranchesState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.branches),
          actions: [
            IconButton(
              key: const Key('AddIcon'),
              tooltip: l10n.addBranch,
              onPressed: () => addBranch(context),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              key: const Key('DeleteIcon'),
              color: _selected.isEmpty ? Theme.of(context).disabledColor : Theme.of(context).iconTheme.color,
              tooltip: l10n.deleteBranch,
              onPressed: () => _selected.isEmpty
                  ? null
                  : {
                      showConfirmMessage(
                        context: context,
                        title: l10n.deleteBranchesQuestion,
                        message: _branchesNameList(_selected),
                        onConfirmButton: () {
                          for (final element in _selected) {
                            context.read<GitBranchesCubit>().delete(element);
                          }
                        },
                      ),
                    },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: _listView(state.branches),
      ),
    );
  }

  void addBranch(BuildContext context) {
    final l10n = context.l10n;
    final gitCalls = context.read<GitCalls>();
    getDirectory(context: context, initialDirectory: '~').then((directory) {
      if (directory != null && directory.isNotEmpty) {
        gitCalls.getGitRepository(directory).then((branchname) {
          gitCalls.getGitOriginRemote(directory).then((origin) {
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
        selectedCallback: (script, selected) {
          setState(() {
            _selected.removeWhere((element) => element.uuid == script.uuid);
            if (selected) {
              _selected.add(script);
            }
          });
        },
      ),
    );
  }
}
