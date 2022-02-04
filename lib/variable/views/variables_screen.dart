import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/variable/variable.dart';
import 'package:overscript/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class VariablesScreen extends StatefulWidget {
  const VariablesScreen({Key? key}) : super(key: key);

  static const routeName = '/variables';
  static MaterialPageRoute pageRoute(BuildContext context) => MaterialPageRoute(
        builder: (BuildContext context) => const VariablesScreen(),
      );

  @override
  VariablesScreenState createState() => VariablesScreenState();
}

class VariablesScreenState extends State<VariablesScreen> {
  final List<Variable> _selected = [];
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    context.read<VariablesCubit>().save(context.read<DataStoreRepository>());
    context.read<DataStoreRepository>().save('test.json');
    super.deactivate();
  }

  String _variablesNameList(List<Variable> variables) {
    final sb = StringBuffer();
    for (final script in variables) {
      sb.writeln(script.name);
    }
    return sb.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<VariablesCubit, VariablesState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.branchScreenTitle),
          actions: [
            IconButton(
              key: const Key('AddIcon'),
              tooltip: l10n.addVariableTooltip,
              onPressed: () => addVariable(context),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              key: const Key('DeleteIcon'),
              color: _selected.isEmpty ? Theme.of(context).disabledColor : Theme.of(context).iconTheme.color,
              tooltip: l10n.deleteVariableTooltip,
              onPressed: () => _selected.isEmpty
                  ? null
                  : {
                      showConfirmMessage(
                        context: context,
                        title: l10n.deleteVariablesConfirmTitle,
                        message: _variablesNameList(_selected),
                        onConfirmButton: () {
                          for (final element in _selected) {
                            context.read<VariablesCubit>().delete(element);
                          }
                        },
                      ),
                    },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: _listView(state.variables),
      ),
    );
  }

  void addVariable(BuildContext context) {
    final l10n = context.l10n;

    showContentDialog(
      context: context,
      title: l10n.addVariableTooltip,
      content: FormBuilder(
        key: _formKey,
        // enabled: false,
        autovalidateMode: AutovalidateMode.disabled,
        initialValue: const {
          'name': '',
          'defaultValue': '',
        },
        skipDisabled: true,
        child: Column(
          children: <Widget>[
            FormBuilderTextField(
              key: const Key('nameInput'),
              autovalidateMode: AutovalidateMode.always,
              name: 'name',
              decoration: InputDecoration(
                labelText: l10n.nameLabel,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
              ]),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            FormBuilderTextField(
              key: const Key('defaultValueInput'),
              autovalidateMode: AutovalidateMode.always,
              name: 'defaultValue',
              decoration: InputDecoration(
                labelText: l10n.defaultValueLabel,
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
            context.read<VariablesCubit>().add(
                  Variable(uuid: const Uuid().v1(), name: _formKey.currentState?.value['name'] as String, defaultValue: _formKey.currentState?.value['defaultValue'] as String),
                ),
          }
      },
    );
  }

  Widget _listView(List<Variable> branches) {
    return ListView.builder(
      itemCount: branches.length,
      itemBuilder: (context, index) => VariableListItem(
        variable: branches[index],
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
