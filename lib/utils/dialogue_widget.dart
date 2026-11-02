import 'package:flutter/material.dart';
import 'package:karamtechnology_services/utils/App_text.dart';

class DialogueWidget {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String cancelText = 'cancel',
    String confirmText = 'confirm',
    Color titleColor = Colors.black,
    Color confirmColor = Colors.deepPurpleAccent,
    IconButton? icon,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: title,
      transitionDuration: const Duration(milliseconds: 300),

      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox();
      },

      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return ScaleTransition(
          scale: curvedAnimation,
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: AppText(
              text: title,
              fontSize: 16,
              color: titleColor,
              textAlign: TextAlign.center,
            ),
            content: AppText(
              text: message,
              fontSize: 14,
              color: Colors.black,
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: AppText(
                  text: cancelText,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: confirmColor,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: AppText(text: confirmText, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
