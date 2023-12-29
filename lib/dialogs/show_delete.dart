import 'package:flutter/material.dart';
import 'package:flutter_learning/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) async {
  return showGenericDialog<bool>(
      context: context,
      title: 'Delete',
      content: 'Are you sure you want to delete this item?',
      optionsBuilder: () => {
            'Cancel': false,
            'Delete': true,
          }).then(
    (value) => value ?? false,
  );
}
