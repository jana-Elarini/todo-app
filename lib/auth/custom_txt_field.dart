import 'package:flutter/material.dart';
import 'package:untitled9/app-colors.dart';

class CustomTxtForm extends StatelessWidget {
  String label;
  TextEditingController controller;
  TextInputType KeyboardType;
  bool obscureText;
  String? Function(String?) validator;

  CustomTxtForm(
      {required this.label,
      required this.controller,
      this.KeyboardType = TextInputType.text,
      this.obscureText = false,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: label,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.primaryColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.primaryColor)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.redColor)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.redColor)),
            errorMaxLines: 2),
        controller: controller,
        keyboardType: KeyboardType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
