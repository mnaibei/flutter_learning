import 'package:flutter/material.dart';
import 'package:flutter_learning/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) async {
  return showGenericDialog<void>(
      context: context,
      title: 'An error occurred',
      content: text,
      optionsBuilder: () => {
            'Ok': null,
          });
}
