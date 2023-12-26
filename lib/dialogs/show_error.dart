import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String message) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('An error occurred'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      });
}
