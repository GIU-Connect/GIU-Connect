import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonName;
  final bool isLoading; // Add this parameter

  const MyButton({
    required this.onTap,
    required this.buttonName,
    this.isLoading = false, // Default to false
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // make the style black and the text white
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      ),
      onPressed: isLoading ? null : onTap, // Disable button when loading
      child: isLoading
          ? const CircularProgressIndicator() // Show progress indicator when loading
          : Text(buttonName),
    );
  }
}
