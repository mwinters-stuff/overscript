// ignore_for_file: use_setters_to_change_properties

import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakeFileSelector extends Fake with MockPlatformInterfaceMixin implements FileSelectorPlatform {
  // Expectations.
  List<XTypeGroup>? acceptedTypeGroups = const <XTypeGroup>[];
  String? initialDirectory;
  String? confirmButtonText;
  String? suggestedName;
  // Return values.
  List<XFile>? files;
  String? path;

  void setExpectations({
    List<XTypeGroup> acceptedTypeGroups = const <XTypeGroup>[],
    String? initialDirectory,
    String? suggestedName,
    String? confirmButtonText,
  }) {
    this.acceptedTypeGroups = acceptedTypeGroups;
    this.initialDirectory = initialDirectory;
    this.suggestedName = suggestedName;
    this.confirmButtonText = confirmButtonText;
  }

  void setFileResponse(List<XFile> files) {
    this.files = files;
  }

  void setPathResponse(String path) {
    this.path = path;
  }

  @override
  Future<XFile?> openFile({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? confirmButtonText,
  }) async {
    expect(acceptedTypeGroups, this.acceptedTypeGroups);
    expect(initialDirectory, this.initialDirectory);
    expect(suggestedName, suggestedName);
    return files?[0];
  }

  @override
  Future<List<XFile>> openFiles({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? confirmButtonText,
  }) async {
    expect(acceptedTypeGroups, this.acceptedTypeGroups);
    expect(initialDirectory, this.initialDirectory);
    expect(suggestedName, suggestedName);
    return files!;
  }

  @override
  Future<String?> getSavePath({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? suggestedName,
    String? confirmButtonText,
  }) async {
    expect(acceptedTypeGroups, this.acceptedTypeGroups);
    expect(initialDirectory, this.initialDirectory);
    expect(suggestedName, this.suggestedName);
    expect(confirmButtonText, this.confirmButtonText);
    return path;
  }

  @override
  Future<String?> getDirectoryPath({
    String? initialDirectory,
    String? confirmButtonText,
  }) async {
    expect(initialDirectory, this.initialDirectory);
    expect(confirmButtonText, this.confirmButtonText);
    return path;
  }
}
