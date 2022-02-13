import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
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
  final _formKey = GlobalKey<FormBuilderState>();

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
    return BlocBuilder<VariablesCubit, VariablesState>(
      builder: (context, state) => BlocBuilder<BranchVariableValuesCubit, BranchVariableValuesState>(
        builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(l10n.variables),
            actions: [
              IconButton(
                key: const Key('AddIcon'),
                tooltip: l10n.addVariable,
                onPressed: () => addVariable(context),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: _listView(state.variables),
        ),
      ),
    );
  }

  void addVariable(BuildContext context) {
    final l10n = context.l10n;

    showContentDialog(
      context: context,
      title: l10n.addVariable,
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
                labelText: l10n.name,
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
                labelText: l10n.defaultValue,
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
                  Variable(
                    uuid: const Uuid().v1(),
                    name: _formKey.currentState?.value['name'] as String,
                    defaultValue: _formKey.currentState?.value['defaultValue'] as String,
                  ),
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
      ),
    );
  }
}
