import 'package:flutter/material.dart';

class MyPackage {
  static Future<bool?> dialogConfirmation(
    BuildContext context, {
    required String title,
    required String content,
    required TextStyle myStyle,
    String textNo = 'No',
    String textYes = 'Yes',
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: myStyle,
          ),
          content: Text(
            content,
            style: myStyle,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                textNo,
                style: myStyle,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                textYes,
                style: myStyle,
              ),
            ),
          ],
        );
      },
    );
  }
}
