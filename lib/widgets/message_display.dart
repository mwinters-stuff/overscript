// import 'package:cool_alert/cool_alert.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';

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

void showConfirmMessage(
    {required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onConfirmButton,
    VoidCallback? onCancelButton}) {
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
// }
