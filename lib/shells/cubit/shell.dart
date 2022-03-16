import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shell.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class Shell extends Equatable {
  const Shell({required this.uuid, required this.command, required this.args});

  const Shell.empty()
      : uuid = '',
        command = '',
        args = const [];

  factory Shell.fromJson(Map json) => _$ShellFromJson(json);

  @JsonKey(required: true)
  final String uuid;
  @JsonKey(required: true)
  final String command;
  @JsonKey(required: true)
  final List<String> args;

  Map<String, dynamic> toJson() => _$ShellToJson(this);
  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [
        uuid,
        command,
        args,
      ];

  Shell copyWithNewArgs({required String newArgs}) {
    return Shell(uuid: uuid, command: command, args: newArgs.split(' '));
  }
}
