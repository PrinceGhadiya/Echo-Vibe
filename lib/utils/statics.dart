import 'package:flutter/material.dart';

Future<void> showErrorDialog(
    {required BuildContext context, required String message}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

kSnackbar({
  required BuildContext context,
  required String msg,
  bool successSnkBar = true,
}) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ),
      backgroundColor: successSnkBar ? Colors.green : Colors.red,
    ));
}
