import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isObsecure = false,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isObsecure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObsecure,
      keyboardType: TextInputType.text,
      style: Theme.of(context).textTheme.labelMedium,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.labelMedium,
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).colorScheme.secondary,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 3,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 3,
          ),
        ),
      ),
    );
  }
}
