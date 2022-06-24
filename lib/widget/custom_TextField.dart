import 'package:flutter/material.dart';
import 'package:seip_day50/widget/brand_colors.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    this.icon,
    this.keytype,
    this.lebelText,
    this.keyy,
    this.maxNumber,
    this.controller,
    this.validator,
    this.data,
    this.hintText,
    this.initialText,
    this.suffixIcon,
    this.formatter,
    this.onChangeFunction,
    this.suffixText,

  });

  final TextEditingController? controller;
  final Function? onChangeFunction;
  final dynamic data;
  final dynamic icon;
  final dynamic suffixIcon;
  final String? initialText;
  final dynamic? validator;
  final String? hintText;
  final int? maxNumber;
  final String? lebelText;
  final dynamic formatter;
  final dynamic keytype;
  final String? suffixText;

  final String? keyy;

  //final dynamic? obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        //minLines: 1,
        maxLines: maxNumber,
        initialValue: initialText,
        keyboardType: keytype,
        controller: controller,
        inputFormatters: formatter,
        validator: validator,
        autofocus: false,
        style: myStyle(14.0, Colors.black54),
        decoration: InputDecoration(
          hoverColor: Colors.black,
          filled: true,
          suffixText: suffixText,
          errorStyle:
              myStyle(12, Colors.redAccent.withOpacity(0.9), FontWeight.w500),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: pinkColor, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: pinkColor,
              width: 1,
            ),
          ),
          labelText: hintText,
          hintStyle: myStyle(12, Colors.black54),
          suffixIcon: suffixIcon,
          prefixIcon: icon,
          labelStyle: myStyle(12, Colors.black54),
          hintText: lebelText,
        ),
      ),
    );
  }
}
