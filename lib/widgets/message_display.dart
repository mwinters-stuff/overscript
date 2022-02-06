// import 'package:cool_alert/cool_alert.dart';
import 'package:fialogs/fialogs.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:overscript/l10n/l10n.dart';
import 'package:path/path.dart';

// class MessageDisplay {
void showErrorMessage({
  required BuildContext context,
  required String title,
  required String message,
}) {
  errorDialog(
    context,
    title,
    message,
    neutralButtonText: 'Ok',
  );
}

void showWarningMessage({
  required BuildContext context,
  required String title,
  required String message,
}) {
  warningDialog(
    context,
    title,
    message,
    neutralButtonText: 'Ok',
  );
}

void showInfoMessage({
  required BuildContext context,
  required String title,
  required String message,
}) {
  infoDialog(
    context,
    title,
    message,
    neutralButtonText: 'Ok',
  );
}

void showSuccessMessage({
  required BuildContext context,
  required String title,
  required String message,
}) {
  successDialog(
    context,
    title,
    message,
    neutralButtonText: 'Ok',
  );
}

void showConfirmMessage({
  required BuildContext context,
  required String title,
  required String message,
  VoidCallback? onConfirmButton,
  VoidCallback? onCancelButton,
}) {
  confirmationDialog(
    context,
    title,
    message,
    positiveButtonText: 'Ok',
    negativeButtonText: 'Cancel',
    positiveButtonAction: () {
      if (onConfirmButton != null) {
        onConfirmButton();
      }
    },
    negativeButtonAction: () {
      if (onCancelButton != null) {
        onCancelButton();
      }
    },
    confirmationDialog: false,
    hideNeutralButton: true,
  );
}

void showContentDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  VoidCallback? onConfirmButton,
  VoidCallback? onCancelButton,
}) {
  customAlertDialog(
    context,
    Text(title),
    content,
    positiveButtonText: 'Ok',
    negativeButtonText: 'Cancel',
    positiveButtonAction: () {
      if (onConfirmButton != null) {
        onConfirmButton();
      }
    },
    negativeButtonAction: () {
      if (onCancelButton != null) {
        onCancelButton();
      }
    },
    hideNeutralButton: true,
  );
}

void showInputDialog({
  required BuildContext context,
  required String title,
  required String label,
  required String value,
  dynamic Function(String)? onConfirmButton,
  VoidCallback? onCancelButton,
}) {
  singleInputDialog(
    context,
    title,
    DialogTextField(label: label, value: value),
    positiveButtonText: 'Ok',
    negativeButtonText: 'Cancel',
    positiveButtonAction: (String newValue) {
      if (onConfirmButton != null) {
        onConfirmButton(newValue);
      }
    },
    negativeButtonAction: () {
      if (onCancelButton != null) {
        onCancelButton();
      }
    },
    hideNeutralButton: true,
  );
}

Future<String?> getDirectory({required BuildContext context, required String initialDirectory}) async {
  return getDirectoryPath(initialDirectory: initialDirectory, confirmButtonText: context.l10n.select);
}

Future<String?> getFile({required BuildContext context, required String currentFile}) async {
  return getSavePath(initialDirectory: dirname(currentFile), suggestedName: basename(currentFile), confirmButtonText: context.l10n.select);
}
// }
