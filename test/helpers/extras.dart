import 'package:file/file.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

FileSystem mockDataStoreRepositoryJsonFile() {
  const fileContents =
      '{"scripts": [], "branchVariables": [{"uuid": "v-uuid-1", "name": "variable1", "defaultValue": "default1"}], "branches": [{"uuid": "a-uuid-1", "name": "master", "directory": "/home/user/src/project", "origin": "git:someplace/bob"}], "branchVariableValues": [{"uuid": "bvv-uuid-1", "branchUuid": "a-uuid-1", "variableUuid": "v-uuid-1", "value": "start value 1"}]}';

  final mockFileSystem = MockFileSystem();

  final mockFile = MockFile();

  when(mockFile.readAsStringSync).thenReturn(fileContents);
  when(mockFile.readAsString).thenAnswer((_) => Future.value(fileContents));

  when(() => mockFileSystem.isFileSync('a-file.json')).thenReturn(true);
  when(() => mockFileSystem.file('a-file.json')).thenReturn(mockFile);
  return mockFileSystem;
}