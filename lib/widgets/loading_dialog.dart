import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;
  const LoadingDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        key: key,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(message! + ", Please wait....")
          ],
        ));
  }
}
