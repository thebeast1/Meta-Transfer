import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta_transfer/constants/my_colors.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final Function(String) onChange;
  final Function(String) onSubmit;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPassword;
  final TextInputType inputType;
  final Color bgColor;

  CustomInput(
      {this.hintText,
      this.inputType = TextInputType.text,
      this.onChange,
      this.onSubmit,
      this.focusNode,
      this.textInputAction,
      this.isPassword,
      this.bgColor = fieldColorBG6});

  @override
  Widget build(BuildContext context) {
    bool _isPassword = isPassword ?? false;

    return Container(
      height: 52,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 7,
          offset: Offset(5, 7), // changes position of shadow
        ),
      ], color: bgColor, borderRadius: BorderRadius.circular(12.0)),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextField(
          obscureText: _isPassword,
          keyboardType: inputType,
          onSubmitted: onSubmit,
          focusNode: focusNode,
          onChanged: onChange,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              color: textBlueColorBG2,
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0),
          ),
          style: KRegularDarkText,
        ),
      ),
    );
  }
}
