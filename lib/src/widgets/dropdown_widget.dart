import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownWidget({
    required this.hint,
    this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: const UnderlineInputBorder(),
          filled: true,
          fillColor: Colors.transparent,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: Colors.grey[850],
            value: value,
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: const TextStyle(color: Colors.white)),
                    ))
                .toList(),
            onChanged: onChanged,
            hint: Text(hint, style: const TextStyle(color: Colors.white70)),
          ),
        ),
      ),
    );
  }
}
