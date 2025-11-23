import 'package:flutter/material.dart';

/// Uniform text field wrapper for Talala forms.
class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    required this.controller,
    this.hint,
    this.icon,
    this.keyboardType,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? hint;
  final IconData? icon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        hintText: hint,
      ),
    );
  }
}
