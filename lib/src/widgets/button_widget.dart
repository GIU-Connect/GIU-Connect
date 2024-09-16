import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final bool isLoading; // New parameter
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.isActive,
    this.isLoading = false, // Default value is false
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isActive ? (isLoading ? null : onPressed) : null, // Disable while loading
      style: ElevatedButton.styleFrom(
        backgroundColor: isLoading ? Colors.grey : null, // Grey color when loading
      ),
      child: isLoading
          ? const SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0, // Adjust thickness for better aesthetics
              ),
            )
          : Text(text),
    );
  }
}
