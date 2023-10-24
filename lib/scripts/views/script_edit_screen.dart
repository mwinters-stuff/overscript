import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/scripts/scripts.dart';
import 'package:overscript/shells/shells.dart';
import 'package:overscript/widgets/form_builder_list.dart';

class ScriptEditArguments {
  ScriptEditArguments(this.uuid);

  final String uuid;
}

class ScriptEditScreen extends StatelessWidget {
  ScriptEditScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  static const actionIcon = LineIcons.code;
  static const routeName = '/edit_script';
  static MaterialPageRoute pageRoute(BuildContext context, {RouteSettings? settings}) => MaterialPageRoute(
        builder: (BuildContext context) => ScriptEditScreen(),
        settings: settings,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final uuid = ModalRoute.of(context)!.settings.arguments as String?;

    final script = context.read<ScriptsCubit>().get(uuid ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(script == null ? l10n.addScript : l10n.editScript),
        // actions: [
        //   IconButton(
        //     key: const Key('AddIcon'),
        //     tooltip: l10n.addScript,
        //     onPressed: () => addScript(context),
        //     icon: const Icon(LineIcons.plusCircle),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          // enabled: false,
          autovalidateMode: AutovalidateMode.disabled,
          initialValue: {
            'name': script?.name,
            'shell': script != null ? context.read<ShellsCubit>().get(script.shellUuid) : context.read<ShellsCubit>().state.shells.first,
            'command': script?.command,
            'args': script?.args,
            'workingDirectory': script?.workingDirectory,
            'runInDocker': script?.runInDocker,
            'envVars': script?.envVars,
          },
          skipDisabled: true,
          child: Column(
            children: <Widget>[
              FormBuilderTextField(
                key: const Key('nameInput'),
                autovalidateMode: AutovalidateMode.always,
                name: 'name',
                decoration: InputDecoration(
                  labelText: l10n.name,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              FormBuilderDropdown<Shell>(
                key: const Key('shellDropdown'),
                name: 'shell',
                decoration: InputDecoration(
                  labelText: l10n.shell,
                ),
                items: _shellDropDownItems(context),
              ),
              FormBuilderTextField(
                key: const Key('commandInput'),
                autovalidateMode: AutovalidateMode.always,
                name: 'command',
                decoration: InputDecoration(
                  labelText: l10n.command,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              FormBuilderList(
                key: const Key('argumentsInput'),
                // autovalidateMode: AutovalidateMode.always,
                name: 'args',
                decoration: InputDecoration(
                  labelText: l10n.arguments,
                ),
                initialValue: ["One", "Two", "Three"],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<Shell>> _shellDropDownItems(BuildContext context) {
    final list = <DropdownMenuItem<Shell>>[];
    for (final shell in context.read<ShellsCubit>().state.shells) {
      list.add(
        DropdownMenuItem<Shell>(
          value: shell,
          child: Text('${shell.command} ${shell.args.join(' ')}'),
        ),
      );
    }
    return list;
  }
}
