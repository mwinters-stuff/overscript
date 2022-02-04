import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/theme/cubit/theme_cubit.dart';
import 'package:overscript/widgets/widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool useKitty = false;

  // Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: 0, vsync: this);
    // if (state.terminals.isNotEmpty) {
    //   _tabController.animateTo(state.terminals.length - 1);
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Close All Tabs',
            onPressed: () {
              // RepositoryProvider.of<PtyRepository>(context).closeAll(context);
              // RepositoryProvider.of<KittyRepository>(context).closeAll(context);
            },
          ),
          IconButton(
            tooltip: 'Reload Scripts',
            onPressed: () => {
              showErrorMessage(
                context: context,
                title: 'Error test',
                message: 'Error',
              )
              //  BlocProvider.of<OldScriptsBloc>(context).add(OldScriptsReloadedEvent(context: context))
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Edit Scripts',
            onPressed: () => {
              // Process.runSync(configurationRepository.editorExecutable.getValue(), [p.join(configurationRepository.scriptPath.getValue(), 'scripts.yaml')])
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            tooltip: 'Scripts',
            onPressed: () => {}, //Navigator.of(context).pushNamed('ScriptsScreen.routeName'),
            icon: const Icon(Icons.subscript_sharp),
          ),
          IconButton(
            tooltip: 'Branches',
            onPressed: () => Navigator.of(context).pushNamed(BranchesScreen.routeName),
            icon: const Icon(Icons.texture_rounded),
          ),
          IconButton(
            tooltip: 'Variables',
            onPressed: () => {}, //Navigator.of(context).pushNamed('VariablesScreen.routeName'),
            icon: const Icon(Icons.vertical_distribute),
          ),
          IconButton(
            icon: Icon(
              context.read<ThemeCubit>().state.status.isLight ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () => context.read<ThemeCubit>().toggle(),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () => {}, //Navigator.of(context).pushNamed('SettingsScreen.routeName'),
            icon: const Icon(Icons.settings),
          )
        ],
        // bottom: TabBar(controller: _tabController, tabs: state.getTabs(context: context)),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 300,
            child: Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Branch',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    //BranchPopupMenu(initialValue: configurationRepository.selectedBranchName.getValue(), onChanged: (value) => configurationRepository.selectedBranchName.setValue(value)),
                    Text(
                      'Options',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    CheckboxListTile(
                      value: useKitty,
                      onChanged: (value) {
                        setState(() {
                          useKitty = value!;
                          // configurationRepository.useKitty.setValue(value);
                        });
                      },
                      title: const Text('External Terminal'),
                    ),
                    Text(
                      'Script',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Container(), // const ScriptMenu(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [], //state.getTabViews(),
            ),
          )
        ],
      ),
    );
  }
}
