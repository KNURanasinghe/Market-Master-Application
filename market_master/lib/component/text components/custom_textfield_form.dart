import 'package:flutter/material.dart';

class CustomTextFeildsForm extends StatelessWidget {
  String labelText;
  final String? Function(String?) validator;
  bool isPassword;
  TextEditingController controller;
  CustomTextFeildsForm(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.validator,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x6699F69D), // 40% opacity
              Color(0xFF3DBD42), // No opacity
            ],
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
          validator: validator,
          obscureText: isPassword,
        ),
      ),
    );
  }
}
