import 'package:flutter/material.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class AuthTextField extends StatelessWidget {
  final dynamic controller;
  final String hintText;
  final bool obscureText;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: TextFormField(
        controller: controller,
        autofocus: false,
        autofillHints: const [AutofillHints.email],
        obscureText: obscureText,

        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: UIText.small.copyWith(color: UIColours.secondaryText),

          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: UIColours.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: UIColours.blue,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),

          filled: true,
          fillColor: UIColours.white
        ),

        style: UIText.small,
      ),
    );
  }
}
