import 'dart:io';

import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/shells/shells.dart';
import 'package:overscript/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class ShellsScreen extends StatefulWidget {
  const ShellsScreen({Key? key}) : super(key: key);

  static const actionIcon = LineIcons.terminal;
  static const routeName = '/shells';
  static MaterialPageRoute pageRoute(BuildContext context) => MaterialPageRoute(
        builder: (BuildContext context) => const ShellsScreen(),
      );

  @override
  ShellsScreenState createState() => ShellsScreenState();
}

class ShellsScreenState extends State<ShellsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    // context.read<VariablesCubit>().save();
    context.read<DataStoreRepository>().save('test.json');
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ShellsCubit, ShellsState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.shells),
          actions: [
            IconButton(
              key: const Key('AddIcon'),
              tooltip: l10n.addShell,
              onPressed: () => addShell(context),
              icon: const Icon(LineIcons.plusCircle),
            ),
          ],
        ),
        body: _listView(state.shells),
      ),
    );
  }

  void addShell(BuildContext context) {
    // final l10n = context.l10n;

    final _formKey = GlobalKey<FormBuilderState>();

    final l10n = context.l10n;
    final commandEditingController = TextEditingController()..text = '';

    showContentDialog(
      context: context,
      title: l10n.addShell,
      content: FormBuilder(
        key: _formKey,
        // enabled: false,
        autovalidateMode: AutovalidateMode.disabled,
        initialValue: const {
          'command': '',
          'args': '',
        },
        skipDisabled: true,
        child: Column(
          children: <Widget>[
            FormBuilderTextField(
              key: const Key('commandInput'),
              autovalidateMode: AutovalidateMode.always,
              name: 'command',
              controller: commandEditingController,
              decoration: InputDecoration(
                labelText: l10n.command,
                suffix: IconButton(
                  key: const Key('selectFileButton'),
                  tooltip: l10n.selectFile,
                  onPressed: () {
                    getFile(
                      context: context,
                      currentFile: commandEditingController.text,
                    ).then((value) {
                      if (value != null && value.isNotEmpty) {
                        commandEditingController.text = value;
                      }
                    });
                  },
                  icon: const Icon(LineIcons.file),
                ),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                (value) {
                  if (value != null && context.read<FileSystem>().isFileSync(value)) return null;
                  return 'File does not exist';
                }
              ]),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            FormBuilderTextField(
              key: const Key('argsInput'),
              autovalidateMode: AutovalidateMode.always,
              name: 'args',
              decoration: InputDecoration(
                labelText: l10n.arguments,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
              ]),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
      onConfirmButton: () => {
        if (_formKey.currentState?.saveAndValidate() ?? false)
          {
            context.read<ShellsCubit>().add(
                  Shell(
                    uuid: const Uuid().v1(),
                    command: _formKey.currentState?.value['command'] as String,
                    args: (_formKey.currentState?.value['args'] as String).split(' '),
                  ),
                ),
          },
      },
    );
  }

  Widget _listView(List<Shell> shells) {
    return ListView.builder(
      itemCount: shells.length,
      itemBuilder: (context, index) => ShellListItem(
        shell: shells[index],
      ),
    );
  }
}
