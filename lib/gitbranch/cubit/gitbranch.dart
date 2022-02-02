// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gitbranch.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
)
class GitBranch extends Equatable {
  const GitBranch({
    required this.uuid,
    required this.name,
    required this.directory,
    required this.origin,
  });

  const GitBranch.empty()
      : uuid = '',
        name = '',
        directory = '',
        origin = '';

  factory GitBranch.fromJson(Map json) => _$GitBranchFromJson(json);

  @JsonKey(required: true)
  final String uuid;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String directory;
  @JsonKey(required: true)
  final String origin;

  Map<String, dynamic> toJson() => _$GitBranchToJson(this);
  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [uuid, name, directory, origin];
}
