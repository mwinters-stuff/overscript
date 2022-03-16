import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'script.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class Script extends Equatable {
  const Script({
    required this.uuid,
    required this.shellUuid,
    required this.name,
    required this.command,
    required this.args,
    required this.workingDirectory,
    required this.runInDocker,
    required this.envVars,
  });

  const Script.empty()
      : uuid = '',
        shellUuid = '',
        name = '',
        command = '',
        args = const [],
        workingDirectory = '',
        runInDocker = false,
        envVars = const {};

  factory Script.fromJson(Map json) => _$ScriptFromJson(json);

  @JsonKey(required: true)
  final String uuid;
  @JsonKey(required: true)
  final String shellUuid;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String command;
  @JsonKey(required: true)
  final List<String> args;
  @JsonKey(required: true)
  final String workingDirectory;
  @JsonKey(required: true)
  final bool runInDocker;
  @JsonKey(required: true)
  final Map<String, String> envVars;

  Map<String, dynamic> toJson() => _$ScriptToJson(this);
  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [uuid, shellUuid, name, command, args, workingDirectory, runInDocker, envVars];
}
