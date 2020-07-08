import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFormField extends StatelessWidget {

  final String labelText;
  final TextInputType keyboardType;

  InputFormField({ @required this.labelText, this.keyboardType = TextInputType.text });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 28, top: 14, bottom: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: Color(0xff8d6e52), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: Color(0xff8d6e52), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: Color(0xff8d6e52), width: 2),
        ),
        labelText: labelText,
        labelStyle:
            TextStyle(color: Theme.of(context).primaryColor),
      ),
      style: TextStyle(
        color: Theme.of(context).primaryColor
      ),
      keyboardType: this.keyboardType,
      cursorColor: Color(0xff8d6e52),
    );
  }
}
