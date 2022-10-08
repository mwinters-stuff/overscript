import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:overscript/scripts/scripts.dart';
import 'package:overscript/shells/cubit/shells_cubit.dart';
import 'package:overscript/widgets/widgets.dart';

class ScriptListItem extends StatefulWidget {
  const ScriptListItem({Key? key, required this.script}) : super(key: key);

  final Script script;

  @override
  ScriptListItemState createState() => ScriptListItemState();
}

class ScriptListItemState extends State<ScriptListItem> {
  var _argumentsExpanded = false;
  var _envExpanded = false;
  var _expanded = false;

  @override
  void initState() {
    super.initState();
    _argumentsExpanded = false;
    _envExpanded = false;
    _expanded = false;
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
                  widget.script.name,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: Text(_expanded ? '' : '${widget.script.command} ${widget.script.args.join(' ')}', textAlign: TextAlign.start),
              ),
            ],
          ),
          trailing: Wrap(
            spacing: 8,
            children: [
              IconButton(
                key: const Key('editValueButton'),
                tooltip: l10n.editScript,
                onPressed: () {
                  Navigator.of(context).pushNamed(ScriptEditScreen.routeName, arguments: widget.script.uuid);
                },
                icon: const Icon(LineIcons.edit),
              ),
              IconButton(
                key: const Key('delete'),
                tooltip: l10n.deleteScript,
                onPressed: () => showConfirmMessage(
                  context: context,
                  title: l10n.deleteScriptQuestion,
                  message: widget.script.name,
                  onConfirmButton: () => context.read<ScriptsCubit>().delete(widget.script),
                ),
                icon: const Icon(LineIcons.alternateTrash),
              ),
            ],
          ),
          children: [
            _createListItem(l10n.shell, context.read<ShellsCubit>().get(widget.script.shellUuid)!.command),
            _createListItem(l10n.command, widget.script.command),
            _createArgsListItem(l10n.arguments, widget.script.args),
            _createListItem(l10n.workingDirectory, widget.script.workingDirectory),
            _createEnvListItem(l10n.environmentVariables, widget.script.envVars),
          ],
          onExpansionChanged: (expanded) => setState(
            () {
              _expanded = expanded;
            },
          ),
        ),
      ),
    );
  }

  Widget _createListItem(String name, String value) {
    return ListTile(
      key: Key('${widget.script.name}-$name'),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              name,
              textAlign: TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Text(value, textAlign: TextAlign.start),
          ),
        ],
      ),
    );
  }

  Widget _createArgsListItem(String name, List<String> values) {
    return ExpansionTile(
      key: Key('${widget.script.name}-$name'),
      controlAffinity: ListTileControlAffinity.leading,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              name,
              textAlign: TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Text(
              _argumentsExpanded ? '' : values.join(' '),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      children: _argsItems(values),
      onExpansionChanged: (expanded) => setState(() {
        _argumentsExpanded = expanded;
      }),
    );
  }

  List<Widget> _argsItems(List<String> values) {
    final widgets = <Widget>[];
    for (final value in values) {
      widgets.add(ListTile(title: Text(value)));
    }
    return widgets;
  }

  Widget _createEnvListItem(String name, Map<String, String> values) {
    return ExpansionTile(
      key: Key('${widget.script.name}-$name'),
      controlAffinity: ListTileControlAffinity.leading,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              name,
              textAlign: TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              _envExpanded ? '' : _envValues(values),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      children: _envItems(values),
      onExpansionChanged: (expanded) => setState(() {
        _envExpanded = expanded;
      }),
    );
  }

  String _envValues(Map<String, String> values) {
    final out = StringBuffer();

    for (final value in values.entries) {
      if (out.isNotEmpty) {
        out.write(', ');
      }
      out.write('${value.key} = ${value.value}');
    }
    return out.toString();
  }

  List<Widget> _envItems(Map<String, String> values) {
    final widgets = <Widget>[];
    for (final value in values.entries) {
      widgets.add(ListTile(title: Text('${value.key} = ${value.value}')));
    }
    return widgets;
  }
}
