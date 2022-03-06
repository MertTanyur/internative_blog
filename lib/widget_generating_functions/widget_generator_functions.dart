import 'package:flutter/material.dart';
import 'dart:ui';

Future<dynamic> showSignError(
    BuildContext context, String title, String contentMessage) {
  return showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        actionsAlignment: MainAxisAlignment.center,
        title: Text(title),
        content: Text(contentMessage),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.pop(context, 'Ok');
            },
          )
        ],
      ),
    ),
  );
}

Future<dynamic> showError(
    BuildContext context, String title, String contentMessage) {
  return showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        actionsAlignment: MainAxisAlignment.center,
        title: Text(title),
        content: Text(contentMessage),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.pop(context, 'Ok');
            },
          )
        ],
      ),
    ),
  );
}
