import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String title;
  final Color backgroundColor, TextColor;
  final Function onPressed;

  LoginButton(
      {this.title, this.backgroundColor, this.TextColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 45,
        width: 120,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(5, 7), // changes position of shadow
          ),
        ], color: backgroundColor, borderRadius: BorderRadius.circular(48)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: TextColor,
            ),
          ),
        ),
      ),
    );
  }
}
