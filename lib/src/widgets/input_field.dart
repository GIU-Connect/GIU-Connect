import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String? labelText;
  final Function(String)? onChanged;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool autoFocus;
  final bool obscureText;
  final TextEditingController? controller; // Add controller

  const InputField({
    this.labelText,
    this.onChanged,
    this.errorText,
    this.keyboardType,
    this.autoFocus = false,
    this.obscureText = false,
    this.controller, // Add controller to constructor
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // Pass controller to TextField
      autofocus: autoFocus,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[500]),
        errorText: errorText,
        errorStyle: const TextStyle(color: Colors.red),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
      ),
    );
  }
}
