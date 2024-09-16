import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonName;
  final bool isLoading;
  final Color color;

  const MyButton({
    required this.onTap,
    required this.buttonName,
    this.isLoading = false,
    this.color = Colors.purple, // Default to purple to match design
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      onPressed: isLoading ? null : onTap,
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(buttonName, style: const TextStyle(color: Colors.white)),
    );
  }
}
