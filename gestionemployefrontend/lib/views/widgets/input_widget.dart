import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    this.validator,
  });

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.poppins(),
        validator : validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
