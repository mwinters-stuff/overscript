import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/widgets/widgets.dart';

class ValueEditDialog {
  final _formKey = GlobalKey<FormBuilderState>();

  void showDialog({
    required BuildContext context,
    required String nameValue,
    required String initialValue,
    required String dialogTitle,
    required String valueCaption,
    required Function(String name, String value) confirmCallback,
    Function()? cancelCallback,
    bool showDirFileButtons = true,
  }) {
    final l10n = context.l10n;
    final valueEditingController = TextEditingController()..text = initialValue;

    showContentDialog(
      context: context,
      title: dialogTitle,
      content: FormBuilder(
        key: _formKey,
        // enabled: false,
        autovalidateMode: AutovalidateMode.disabled,
        initialValue: {
          'name': nameValue,
          'value': initialValue,
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
              key: const Key('valueInput'),
              controller: valueEditingController,
              autovalidateMode: AutovalidateMode.always,
              name: 'value',
              decoration: InputDecoration(
                labelText: valueCaption,
                suffix: showDirFileButtons
                    ? Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            key: const Key('selectDirectoryButton'),
                            tooltip: l10n.selectDirectory,
                            onPressed: () {
                              getDirectory(
                                context: context,
                                initialDirectory: valueEditingController.text,
                              ).then(
                                (value) {
                                  if (value != null && value.isNotEmpty) {
                                    valueEditingController.text = value;
                                  }
                                },
                              );
                            },
                            icon: const Icon(LineIcons.folder),
                          ),
                          IconButton(
                            key: const Key('selectFileButton'),
                            tooltip: l10n.selectFile,
                            onPressed: () {
                              getFile(
                                context: context,
                                currentFile: valueEditingController.text,
                              ).then((value) {
                                if (value != null && value.isNotEmpty) {
                                  valueEditingController.text = value;
                                }
                              });
                            },
                            icon: const Icon(LineIcons.file),
                          ),
                        ],
                      )
                    : null,
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
            confirmCallback(
              _formKey.currentState?.value['name'] as String,
              _formKey.currentState?.value['value'] as String,
            )
          }
      },
      onCancelButton: () => {
        if (cancelCallback != null) {cancelCallback()}
      },
    );
  }
}
