import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  String tffInitialValue;
  final InputDecoration tffInputDecoration;
  final int tffMaxLength;
  final TextStyle tffTextStyle;
  final String Function(String) tffValidator;
  final void Function(String) tffOnSaved;

  CustomTextFormField({
    @required this.tffInitialValue,
    this.tffInputDecoration,
    this.tffMaxLength,
    this.tffTextStyle,
    this.tffValidator,
    this.tffOnSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: tffInitialValue,
      decoration: tffInputDecoration,
      maxLength: tffMaxLength,
      style: tffTextStyle,
      validator: tffValidator,
      onSaved: tffOnSaved,
    );
  }
}
