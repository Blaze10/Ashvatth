import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFormField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final String hintText;
  final TextEditingController controller;
  final bool isRequired;
  final Function validatorFunction;
  final bool isDisabled;
  final Widget suffixWidget;
  final Function onTapFunction;
  final bool isDate;
  final bool isMultiline;

  InputFormField({
    @required this.labelText,
    this.keyboardType = TextInputType.text,
    this.hintText = '',
    @required this.controller,
    this.isRequired = false,
    this.validatorFunction,
    this.isDisabled = false,
    this.suffixWidget,
    this.onTapFunction,
    this.isDate = false,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
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
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        hintText: hintText,
        suffixIcon: suffixWidget,
      ),
      style: TextStyle(color: Theme.of(context).primaryColor),
      keyboardType: this.keyboardType,
      readOnly: isDisabled,
      onTap: !isDate ? null : onTapFunction,
      minLines: isMultiline ? 3 : 1,
      maxLines: isMultiline ? 3 : 1,
      validator: validatorFunction != null
          ? validatorFunction
          : (value) {
              if (isRequired) {
                if (value.trim().isEmpty) {
                  return 'This field is required';
                }
              }
              return null;
            },
      cursorColor: Color(0xff8d6e52),
    );
  }
}
