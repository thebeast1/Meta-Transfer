import 'package:flutter/material.dart';
import 'package:meta_transfer/components/custom_input.dart';
import 'package:meta_transfer/components/login_button.dart';
import 'package:meta_transfer/constants/my_colors.dart';
import 'package:meta_transfer/pages/home_page.dart';
import 'package:meta_transfer/db_handler.dart';
import 'package:meta_transfer/pages/startup_page.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = "", password = "", ID = "", phone = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: BackgroundGradientM2,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Image.asset('assets/app_logo.png'),
                ),
                CustomInput(
                  inputType: TextInputType.emailAddress,
                  hintText: "type your email",
                  onChange: (text) {
                    email = text;
                  },
                ),
                CustomInput(
                  inputType: TextInputType.number,
                  hintText: "type your ID",
                  onChange: (text) {
                    setState(() {
                      ID = text;
                    });
                  },
                ),
                CustomInput(
                  inputType: TextInputType.number,
                  hintText: "type your Phone",
                  onChange: (text) {
                    setState(() {
                      phone = text;
                    });
                  },
                ),
                CustomInput(
                  hintText: "type your Password",
                  onChange: (str) {
                    password = str;
                  },
                  isPassword: true,
                ),
                Builder(
                  builder: (context) => LoginButton(
                    title: "SignUp",
                    backgroundColor: Colors.blue,
                    TextColor: Colors.white,
                    onPressed: ID.length == 14 && phone.length == 11
                        ? () async {
                            String result =
                                await DBHandler.signUp(email, password);
                            if (result.isEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          StartUpPage()));
                            } else {
                              final snackBar = SnackBar(
                                content: Text(result),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                          }
                        : () {
                            String result;
                            if (phone.length != 11 && ID.length != 14)
                              result =
                                  "Check the National Id is 14 digits and phone number is 11 digits.";
                            else if (ID.length != 14) {
                              result = "Check the National Id is 14 digits.";
                            } else if (phone.length != 11)
                              result = "Check the Phone number is 11 digits.";

                            final snackBar = SnackBar(
                              content: Text(result),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );
                            // Find the ScaffoldMessenger in the widget tree
                            // and use it to show a SnackBar.
                            Scaffold.of(context).showSnackBar(snackBar);
                          },
                  ),
                ),
                TextButton(
                  child: Text(
                    "back to Login?",
                    style: KRegularWhiteText,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
