import 'package:flutter/material.dart';

class SuccessDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final Color accentColor;
  final VoidCallback onButtonPressed;
  final IconData icon;

  const SuccessDialogWidget({
    Key? key,
    this.title = 'Амжилттай нэмэгдлээ!',
    required this.message,
    this.buttonText = 'OK',
    this.accentColor = Colors.blue,
    required this.onButtonPressed,
    this.icon = Icons.rocket_launch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1B1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to show the dialog
  static Future<void> show({
    required BuildContext context,
    String title = 'Амжилттай нэмэгдлээ!',
    required String message,
    String buttonText = 'OK',
    Color accentColor = Colors.blue,
    required VoidCallback onButtonPressed,
    IconData icon = Icons.rocket_launch,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SuccessDialogWidget(
          title: title,
          message: message,
          buttonText: buttonText,
          accentColor: accentColor,
          onButtonPressed: () {
            // First close the dialog using the dialog's context
            Navigator.of(dialogContext).pop();
            // Then execute the original callback
            onButtonPressed();
          },
          icon: icon,
        );
      },
    );
  }
}
