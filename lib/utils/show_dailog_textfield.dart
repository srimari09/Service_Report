
import 'package:flutter/material.dart';
import 'package:karamtechnology_services/utils/App_text.dart';

class ShowDailogTextfield {
static Future<String?> show({
required BuildContext context,
required String title,
required String message,
required TextEditingController fileTextController,
String cancelText = 'cancel',
String confirmText = 'confirm',
Color titleColor = Colors.black,
Color confirmColor = Colors.deepPurpleAccent,
IconButton? icon,
}) async {
return await showDialog<String>(
context: context,
barrierDismissible: true,
barrierLabel: title,
builder: (dialogContext) {
return AlertDialog(
backgroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
title: AppText(
text: title,
fontSize: 16,
color: titleColor,
textAlign: TextAlign.center,
),
content: TextField(
controller: fileTextController,
autofocus: true,
decoration: InputDecoration(
labelText: 'File Name',
hintText: message,
),
),
actionsAlignment: MainAxisAlignment.center,
actions: [
ElevatedButton(
onPressed: () {
Navigator.pop(dialogContext);
},
child: AppText(
text: cancelText,
color: Colors.deepPurpleAccent,
),
),
ElevatedButton(
onPressed: () {
final name = fileTextController.text.trim();

if (name.isEmpty) {
return;
}

Navigator.pop(dialogContext, name);
},
style: ElevatedButton.styleFrom(
backgroundColor: confirmColor,
foregroundColor: Colors.white,
elevation: 4,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
child: AppText(
text: confirmText,
color: Colors.white,
),
),
],
);
},
);
}
}
