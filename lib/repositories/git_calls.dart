import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:process/process.dart';

class GitCalls {
  GitCalls(this.processManager);

  final ProcessManager processManager;

  Future<String> getBranchName(String directory) {
    final gitbranch = processManager.runSync(
      ['git', '-C', directory, 'rev-parse', '--abbrev-ref', 'HEAD'],
    );
    if (gitbranch.stderr != '') {
      return Future.error(gitbranch.stderr.toString().trim());
    }
    return Future<String>.value(gitbranch.stdout.toString().trim());
  }

  Future<String> getOriginRemote(String directory) {
    final gitremote = processManager.runSync(['git', '-C', directory, 'remote', '-v']);
    if (gitremote.stderr != '') {
      return Future.error(gitremote.stderr.toString().trim());
    }

    const lineSplitter = LineSplitter();
    final lines = lineSplitter.convert(gitremote.stdout.toString().trim());
    for (final line in lines) {
      final parts = line.split(RegExp(r'\s'));
      if (parts.length == 3) {
        if (parts[0] == 'origin') {
          return Future<String>.value(parts[1]);
        }
      }
    }
    return Future.error(
      'No remote origin\n\n${gitremote.stdout.toString().trim()}',
    );
  }
}
