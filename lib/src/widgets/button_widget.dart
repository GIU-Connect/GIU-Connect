import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final bool isLoading;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.isActive,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isActive ? (isLoading ? null : onPressed) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Make the ElevatedButton background transparent
        foregroundColor: isLoading || !isActive ? Colors.grey[600] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        elevation: isActive ? 3.0 : 0.0,
        shadowColor: Colors.black.withAlpha((0.2 * 255).toInt()),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange[400]!,
                    Colors.orange[700]!,
                  ],
                )
              : null,
          color: isLoading
              ? Colors.grey
              : (!isActive ? Colors.grey[300] : null), // Set color only when not active or loading
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          constraints: const BoxConstraints(minHeight: 50.0), // Ensure minimum height for consistent button size
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  ),
                )
              : Text(text),
        ),
      ),
    );
  }
}
