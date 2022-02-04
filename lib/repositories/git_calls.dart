import 'dart:convert';
import 'dart:core';
import 'dart:io';

class GitCalls {
  Future<String> getGitRepository(String directory) {
    final gitbranch = Process.runSync(
      'git',
      ['-C', directory, 'rev-parse', '--abbrev-ref', 'HEAD'],
    );
    if (gitbranch.stderr != '') {
      return Future.error(gitbranch.stderr.toString().trim());
    }
    return Future.value(gitbranch.stdout.toString().trim());
  }

  Future<String> getGitOriginRemote(String directory) {
    final gitremote = Process.runSync('git', ['-C', directory, 'remote', '-v']);
    if (gitremote.stderr != '') {
      return Future.error(gitremote.stderr.toString().trim());
    }

    const lineSplitter = LineSplitter();
    final lines = lineSplitter.convert(gitremote.stdout.toString().trim());
    for (final line in lines) {
      final parts = line.split(' ');
      if (parts.length == 3) {
        if (parts[0] == 'origin') {
          return Future.value(parts[1]);
        }
      }
    }
    return Future.error(
      'No remote origin\n\n${gitremote.stdout.toString().trim()}',
    );
  }

  Future<String?> getDirectoryPath({
    String? initialDirectory,
    String? confirmButtonText,
  }) {
    return getDirectoryPath(
      confirmButtonText: confirmButtonText,
      initialDirectory: initialDirectory,
    );
  }
}
