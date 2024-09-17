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
        backgroundColor: isLoading ? Colors.grey : (isActive ? Colors.blue : Colors.grey[300]),
        foregroundColor: isLoading || !isActive ? Colors.grey[600] : Colors.white,
        textStyle: TextStyle(
          // Add textStyle to control text color
          color: isLoading || !isActive ? Colors.grey[600] : Colors.white,
        ),
      ),
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
    );
  }
}
